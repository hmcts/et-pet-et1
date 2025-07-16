require 'webmock/rspec'
require_relative './capybara_driver_helper'
app_host_url = URI.parse Capybara.app_host || 'http://localhost'
et_api_url = 'http://api.et.net:4000/api/v2'
build_claim_url = "#{et_api_url}/claims/build_claim"
WebMock.disable_net_connect! allow_localhost: true,
                             allow:           [
                                                app_host_url.host,
                                                "chromedriver.storage.googleapis.com",
                                                'github.com',
                                                'github-production-release-asset-2e65be.s3.amazonaws.com',
                                                'github-releases.githubusercontent.com',
                                                'objects.githubusercontent.com'
                                              ]
RSpec.configure do |c|
  c.around mock_et_api: true do |example|
    ClimateControl.modify ET_API_URL: et_api_url do
      stub_request(:post, build_claim_url).with(headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }).to_return(body: '{}', status: 202, headers: { 'Content-Type': 'application/json' })
      example.run
    end
  end
end
#end
