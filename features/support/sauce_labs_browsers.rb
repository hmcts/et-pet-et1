if ENV['SAUCELABS_ACCOUNT'].present?
  sauce_url = "https://#{ENV['SAUCELABS_ACCOUNT']}:#{ENV['SAUCELABS_API_KEY']}@ondemand.saucelabs.com:443/wd/hub"
  Capybara.register_driver :'sauce-chrome-windows7' do |app|
    caps = {
      :platform => "Windows 7",
      :browserName => "Chrome",
      :version => "45"
    }
    Capybara::Selenium::Driver.new(app, browser: :chrome, url: sauce_url, desired_capabilities: caps)

    Capybara::Screenshot.register_driver(:'sauce-chrome-windows7') do |driver, path|
      driver.browser.save_screenshot(path)
    end
  end
end
