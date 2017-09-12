And(/^I save my refund with a valid email address and password$/) do
  refund_step_one_page.email.set('test@digital.justice.gov.uk')
  refund_step_one_page.memorable_word.set('password')
  refund_step_one_page.save_and_continue.click
end
