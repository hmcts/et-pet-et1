require 'webmock/cucumber'
require_relative './capybara_driver_helper'
allowed = []
allowed << URI.parse(ENV.fetch('SELENIUM_URL', 'http://localhost:4444/wd/hub'))
allowed << URI.parse(Capybara.app_host)
allowed << URI.parse("https://#{ENV['SAUCELABS_ACCOUNT']}:#{ENV['SAUCELABS_API_KEY']}@ondemand.saucelabs.com:443/wd/hub") if ENV['SAUCELABS_ACCOUNT'].present?

WebMock.disable_net_connect!(allow_localhost: true, allow: allowed.map(&:host))
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
