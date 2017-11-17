And(/^I start a new refund$/) do
  visit '/apply/refund'
end

When(/^I start a new refund for a sole party who paid the tribunal fees directly and has not been reimbursed$/) do
  visit '/apply/refund'
  refund_profile_selection_page.select_profile.set('I was an individual claimant who made the payments set out in this application and have not been reimbursed by anyone pursuant to an order of the Tribunal')
  step("I take a screenshot named \"Page 1 - Applicant Type Selector\"")
  refund_profile_selection_page.save_and_continue.click
end

When(/^I start a new refund for an individual claimant whos representative paid the fees and the indivual reimbursed them$/) do
  visit '/apply/refund'
  refund_profile_selection_page.select_profile.set('I was an individual claimant whose representative paid the fee and I then reimbursed them')
  step("I take a screenshot named \"Page 1 - Applicant Type Selector\"")
  refund_profile_selection_page.save_and_continue.click
end
