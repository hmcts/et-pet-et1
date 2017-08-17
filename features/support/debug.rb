After do |scenario|
  if scenario.failed?
    puts "scenario failed"
    puts Capybara.current_session.body
  end
end
