require 'webrick/log'
Capybara.configure do |config|
  driver = ENV['DRIVER']&.to_sym || :chrome
  config.default_driver = driver
  config.default_max_wait_time = 15
  config.match = :prefer_exact
  config.visible_text_only = true

end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false, timeout: 60)
end

Capybara.register_driver :firefox do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile.enable_firebug
  profile['browser.cache.disk.enable'] = false
  profile['browser.cache.memory.enable'] = false
  Capybara::Selenium::Driver.new(app, browser: :firefox, profile: profile)
end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome, url: ENV.fetch('SELENIUM_URL', 'http://localhost:4444/wd/hub'), args: ["--window-size=1600,1000"])
end

Capybara.register_driver :chromedriver do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--no-sandbox')
  options.add_argument('--headless')
  options.add_argument('--lang=en-GB')
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.register_driver :chromevisible do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--no-sandbox')
  options.add_argument('--start-maximized')
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.register_driver :firefoxdriver do |app|
  options = Selenium::WebDriver::Firefox::Options.new
  options.headless!
  Capybara::Selenium::Driver.new(app, browser: :firefox, options: options)
end

Capybara.register_driver :safari do |app|
  Capybara::Selenium::Driver.new(app, browser: :safari)
end

if ENV.key?('CIRCLE_ARTIFACTS')
  Capybara.save_and_open_page_path = ENV['CIRCLE_ARTIFACTS']
end

Capybara::Screenshot.register_driver(:chrome) do |driver, path|
  driver.browser.save_screenshot(path)
end

Capybara.register_driver :safari do |app|
  Capybara::Selenium::Driver.new(app, browser: :safari)
end

Capybara::Screenshot.register_filename_prefix_formatter(:cucumber) do |scenario|
  title = scenario.name.tr(' ', '-').gsub(%r{/^.*\/cucumber\//}, '')
  "screenshot_cucumber_#{title}"
end

Capybara.javascript_driver = Capybara.default_driver
Capybara.current_driver = Capybara.default_driver
Capybara.always_include_port = true
Capybara.app_host = ENV.fetch('CAPYBARA_APP_HOST', "http://#{ENV.fetch('HOSTNAME')}")
Capybara.server_host = ENV.fetch('CAPYBARA_SERVER_HOST', ENV.fetch('HOSTNAME'))
Capybara.server = :webrick, { Logger: WEBrick::Log.new(Rails.logger, WEBrick::Log::DEBUG) }
