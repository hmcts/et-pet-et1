require 'capybara-screenshot/rspec'
Capybara::Screenshot.prune_strategy = :keep_last_run
Capybara::Screenshot.register_driver(:firefox) do |driver, path|
  driver.browser.save_screenshot(path)
end
Capybara::Screenshot.register_driver(:firefox_local) do |driver, path|
  driver.browser.save_screenshot(path)
end
Capybara::Screenshot.register_driver(:firefox_local_visible) do |driver, path|
  driver.browser.save_screenshot(path)
end
Capybara::Screenshot.register_driver(:chrome_local) do |driver, path|
  driver.browser.save_screenshot(path)
end
Capybara::Screenshot.register_driver(:chrome_local_visible) do |driver, path|
  driver.browser.save_screenshot(path)
end
