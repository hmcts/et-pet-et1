Given(/^I am on the landing page$/) do
  new_claim_page.load
  step("I take a screenshot named \"Landing Page\"")
end

And(/^I start a new refund$/) do
  new_claim_page.start_a_refund.click
end

When(/^I start a new refund for a sole party who paid the tribunal fees directly and has not been reimbursed$/) do
  new_claim_page.start_a_refund.click
  refund_profile_selection_page.select_profile.set('I am the claimant who paid the tribunal fees directly and have not been reimbursed by anyone else')
  step("I take a screenshot named \"Page 1 - Applicant Type Selector\"")
  refund_profile_selection_page.save_and_continue.click
end

When(/^I start a new refund for an individual claimant whos representative paid the fees and the indivual reimbursed them$/) do
  new_claim_page.start_a_refund.click
  refund_profile_selection_page.select_profile.set('I was an individual claimant whose representative paid the fee and I then reimbursed them')
  step("I take a screenshot named \"Page 1 - Applicant Type Selector\"")
  refund_profile_selection_page.save_and_continue.click
end

When(/^I start a new refund for an individual claimant who paid a fee to the employment appeal tribunal$/) do
  new_claim_page.start_a_refund.click
  refund_profile_selection_page.select_profile.set('I was an individual claimant to an employment tribunal claim, and I paid a fee to the Employment Appeals Tribunal (whether I was the appellant or respondent to the appeal)')
  step("I take a screenshot named \"Page 1 - Applicant Type Selector\"")
  refund_profile_selection_page.save_and_continue.click
end
