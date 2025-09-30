require "capybara/cuprite"
require 'securerandom'
Capybara.configure do |config|
  driver = ENV['TEST_BROWSER']&.to_sym || :cuprite
  config.default_max_wait_time =5
  config.javascript_driver = driver
end

cuprite_options = {
  'no-sandbox':                  nil,
  'disable-gpu':                 nil,
  'disable-software-rasterizer': nil,
  'disable-dev-shm-usage':       nil,
  'disable-smooth-scrolling':    true,
}
Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(app,
                                window_size: [1600, 1000],
                                timeout: 10,
                                browser_options: cuprite_options,
                                js_errors: true,
                                process_timeout: 30,
                                browser_timeout: 30,)
end

Capybara.register_driver(:cuprite_visible) do |app|
  Capybara::Cuprite::Driver.new(app,
                                window_size: [1600, 1000],
                                headless: false,
                                timeout: 10,
                                browser_options: cuprite_options,
                                js_errors: true,
                                process_timeout: 30,
                                browser_timeout: 30,)
end

Capybara.always_include_port = true

if ENV['TEST_URL'].present?
  Capybara.app_host = ENV['TEST_URL']
  Capybara.run_server = false
else
  Capybara.app_host = ENV.fetch('CAPYBARA_APP_HOST') if ENV.key?('CAPYBARA_APP_HOST')
  Capybara.server_host = ENV.fetch('CAPYBARA_SERVER_HOST') if ENV.key?('CAPYBARA_SERVER_HOST')
end
