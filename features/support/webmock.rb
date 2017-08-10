require 'webmock/cucumber'
require_relative './capybara_driver_helper'
selenium_url = URI.parse ENV.fetch('SELENIUM_URL', 'http://localhost:4444/wd/hub')
app_host_url = URI.parse Capybara.app_host
WebMock.disable_net_connect!(allow_localhost: true, allow: [selenium_url.host, app_host_url.host])
Before('@mock_jadu') do
  url = ENV.fetch('JADU_API')
  stub_request(:post, "#{url}new-claim").to_return do
    {
      status: 200,
      body: "{}",
      headers: {
        'Content-Type' => 'application/json'
      }
    }
  end
end
