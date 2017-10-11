And(/^I select "([^"]*)" from the refund type page$/) do |arg|
  refund_profile_selection_page.select_profile.set(arg)
end

And(/^I save my profile selection on the refund type page$/) do
  refund_profile_selection_page.save_and_continue.click
end

Then(/^the user should be informed that there are errors on the profile selection page$/) do
  expect(refund_profile_selection_page.select_profile.error.text).to eql "Please confirm"
end

Then(/^the continue button should be disabled on the profile selection page$/) do
  expect(refund_profile_selection_page.save_and_continue).to be_disabled
end

Then(/^I should see the profile selection page$/) do
  expect(refund_profile_selection_page).to be_displayed
end
