module ET1
  module Test
    module Setup
      def stub_build_blob_to_s3
        aws_response = Aws::S3::Bucket.new(client: ET1::Test::S3Helpers.configured_test_client, name: ENV.fetch('S3_DIRECT_UPLOAD_BUCKET', 'et1directbuckettest')).
          presigned_post(key: "direct_uploads/#{SecureRandom.uuid}", success_action_status: '201')
        stub_request(:post, "#{ENV.fetch('ET_API_URL', 'http://api.et.127.0.0.1.nip.io:3100/api')}/v2/build_blob").
          to_return(
            headers: { 'Content-Type': 'application/json' },
            body:
              {
                "data": {
                  "fields": aws_response.fields,
                  "url": aws_response.url
                },
                "meta": {
                  "cloud_provider": "amazon"
                },
                "status": "accepted",
                "uuid": SecureRandom.uuid
              }.to_json
          )
      end
    end
  end
end
