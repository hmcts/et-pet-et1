And(/^I select "([^"]*)" from the refund type page$/) do |arg|
  refund_profile_selection_page.select_profile.set(arg)
end


And(/^I save my profile selection on the refund type page$/) do
  refund_profile_selection_page.save_and_continue.click
end
