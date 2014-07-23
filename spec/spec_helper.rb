require 'webmock/rspec'

WebMock.disable_net_connect!(allow: "codeclimate.com")

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
