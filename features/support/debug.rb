After do |scenario|
  if scenario.failed?
    puts "Page url was :-"
    puts Capybara.current_session.current_url
    puts "HTML Was :-"
    puts Capybara.current_session.body
    puts "The selenium log was"
    Capybara.current_session.driver.browser.manage.logs.get(:browser).to_json
  end
end
