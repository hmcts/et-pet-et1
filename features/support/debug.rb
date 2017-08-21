After do |scenario|
  if scenario.failed?
    puts "Page url was :-"
    puts Capybara.current_session.current_url
    puts "HTML Was :-"
    puts Capybara.current_session.body
  end
end
