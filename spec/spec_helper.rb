require 'webmock/rspec'
app_host = ENV.fetch('CAPYBARA_SERVER_HOST', ENV.fetch('HOSTNAME', `hostname`.strip))
selenium_host = URI.parse(ENV.fetch('SELENIUM_URL', 'http://localhost:4444')).host
WebMock.disable_net_connect!(allow: ["codeclimate.com", app_host, "chromedriver.storage.googleapis.com", selenium_host], allow_localhost: true)

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  config.order = :random

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.profile_examples = 10

  Kernel.srand config.seed

  config.filter_run :focus
  config.run_all_when_everything_filtered = true
end
