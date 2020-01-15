Capybara.configure do |config|
  driver = ENV['TEST_BROWSER']&.to_sym || :firefox_local
  config.default_driver = driver
  config.default_max_wait_time = 15
  config.match = :prefer_exact
  config.visible_text_only = true

end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false, timeout: 60)
end

Capybara.register_driver :firefox do |app|
  Capybara::Selenium::Driver.new(app, browser: :firefox, url: ENV.fetch('SELENIUM_URL', 'http://localhost:4444/wd/hub'))
end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome, url: ENV.fetch('SELENIUM_URL', 'http://localhost:4444/wd/hub'), args: ["--window-size=1600,1000"])
end

Capybara.register_driver :chrome_local do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--no-sandbox')
  options.add_argument('--headless')
  options.add_argument('--lang=en-GB')
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.register_driver :chrome_local_visible do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--no-sandbox')
  options.add_argument('--start-maximized')
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.register_driver :firefox_local do |app|
  options = Selenium::WebDriver::Firefox::Options.new
  options.headless!
  Capybara::Selenium::Driver.new(app, browser: :firefox, options: options)
end

Capybara.register_driver :firefox_local_visible do |app|
  Capybara::Selenium::Driver.new(app, browser: :firefox)
end

Capybara.register_driver :safari do |app|
  Capybara::Selenium::Driver.new(app, browser: :safari)
end

if ENV.key?('CIRCLE_ARTIFACTS')
  Capybara.save_and_open_page_path = ENV['CIRCLE_ARTIFACTS']
end

Capybara.register_driver :safari do |app|
  Capybara::Selenium::Driver.new(app, browser: :safari)
end

Capybara.javascript_driver = Capybara.default_driver
Capybara.current_driver = Capybara.default_driver
Capybara.always_include_port = true
if [:firefox, :chrome].include?(Capybara.javascript_driver)
  Capybara.app_host = ENV.fetch('CAPYBARA_APP_HOST', "http://localhost.from.docker")
  Capybara.server_host = ENV.fetch('CAPYBARA_SERVER_HOST', '0.0.0.0')
else
  Capybara.app_host = 'http://localhost'
end
