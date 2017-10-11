And(/^my session dissapears from a timeout$/) do
  browser = Capybara.current_session.driver.browser
  if browser.respond_to?(:clear_cookies)
    # Rack::MockSession
    browser.clear_cookies
  elsif browser.respond_to?(:manage) && browser.manage.respond_to?(:delete_all_cookies)
    # Selenium::WebDriver
    browser.manage.delete_all_cookies
  else
    raise "Don't know how to clear cookies. Weird driver?"
  end
end

Then(/^I should see the profile selection page with a session reloaded message$/) do
  expect(refund_profile_selection_page).to have_session_reloaded_message
end
