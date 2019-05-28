Dir.glob(File.absolute_path('./helpers/**/*.rb', __dir__)).each do |f|
  require f
end

RSpec.configure do |c|
  c.include ET1::Test::Pages, type: feature
  c.include ET1::Test::Setup, type: feature
end

RSpec.configure do |c|
  c.before(:suite) do
    ET1::Test::AzureHelpers.configure_test_container
    ET1::Test::AzureHelpers.configure_cors
  end
end

require 'aws-sdk-s3'

RSpec.configure do |c|
  c.before(:suite) do

    Aws::S3::Bucket.new(client: ET1::Test::S3Helpers.configured_test_client, name: ENV.fetch('S3_DIRECT_UPLOAD_BUCKET', 'et1directbuckettest')).tap do |bucket|
      begin
        bucket.create unless bucket.exists?
      rescue Aws::S3::Errors::BucketAlreadyOwnedByYou
        Rails.logger.warn "AWS: Potential race condition, attempted to create bucket despite detecting it as non-existent"
      end
      bucket.objects.each(&:delete)
    end
  end
end
