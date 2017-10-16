require 'capybara/poltergeist'
Capybara.configure do |config|
  config.default_max_wait_time = 10
  config.javascript_driver = :poltergeist
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false, timeout: 60)
end
