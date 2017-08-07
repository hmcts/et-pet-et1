And(/^I save my claim with a valid email address and password$/) do
  step_one_page.email.set('test@digital.justice.gov.uk')
  step_one_page.memorable_word.set('password')
  step_one_page.save_and_continue.click
end
