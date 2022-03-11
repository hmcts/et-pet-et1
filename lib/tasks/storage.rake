require 'securerandom'
namespace :storage do
  desc 'Updates any non submitted claims which have group claims csv in S3'
  task update_group_claims_csv: :environment do
    build_blob_service_class = Class.new(::ApiService) do
      def submit
        json = {
          uuid: SecureRandom.uuid,
          command: "BuildBlob",
          data: {
            preventEmptyData: true
          }
        }
        response = send_request(json.to_json, path: '/build_blob', subject: 'Build Blob for data transfer rake task')
        JSON.parse(response.body)
      end
    end

    upgraded = []
    errors = []
    scope = Claim.where.not(state: :submitted).where.not(additional_claimants_csv: nil).where("additional_claimants_csv NOT LIKE '---%'")
    puts "#{scope.count} to be upgraded"
    credentials = {
      provider:              'AWS',
      region:                ENV.fetch('AWS_REGION', 'eu-west-1'),
      aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'] || '',
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] || ''
    }
    if ENV.key?('AWS_ENDPOINT')
      credentials[:endpoint] = ENV['AWS_ENDPOINT']
      credentials[:host] = URI.parse(ENV['AWS_ENDPOINT']).host
    end
    credentials[:path_style] = true if ENV.fetch('AWS_S3_FORCE_PATH_STYLE', 'false') == 'true'
    connection = Fog::Storage.new(credentials)
    bucket = connection.directories.new(key: ENV['S3_UPLOAD_BUCKET'])

    build_blob_service = build_blob_service_class.new
    hydra = Typhoeus::Hydra.new max_concurrency: 1

    scope.all.each do |claim|
      filename = claim.attributes['additional_claimants_csv']
      key = "uploads/claim/additional_claimants_csv/#{claim.reference}/#{filename}"
      file = bucket.files.get(key)
      next if file.nil?

      response = build_blob_service.submit

      file_key = response.dig('data', 'fields', 'key')
      request = Typhoeus::Request.new response.dig('data', 'url'),
                                      verbose: true, method: :put, body: file.body,

                                      headers: { 'x-ms-blob-type': 'BlockBlob', 'Content-Type' => file.content_type }
      hydra.queue(request)
      hydra.run

      if request.response.code == 201
        claim.additional_claimants_csv = { filename: filename, content_type: file.content_type, path: file_key }.with_indifferent_access
        claim.save validate: false, touch: false
        upgraded << claim
      else
        errors << claim
      end
    end

    puts "A total of #{upgraded.length} were updated"
    puts "The following claims were not upgraded due to errors\n\n  #{errors.map(&:fee_group_reference).join("\n  ")}"
  end
end
