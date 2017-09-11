And(/^I save my claim with a valid email address and password$/) do
  step_one_page.email.set('test@digital.justice.gov.uk')
  step_one_page.memorable_word.set('password')
  # The sleep below should not be required - but for some reason the button does not seem to be clickable
  # when run in the CI environment - it says Element is not clickable at point (123, 921)
  sleep 0.5
  # @TODO Remove once real reason is discovered and fixed
  step_one_page.save_and_continue.click
end
