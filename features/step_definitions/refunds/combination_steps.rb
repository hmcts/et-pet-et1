And(/^I fill in the refund forms and accept the declaration$/) do
  step 'I fill in my refund applicant details'
  step 'I fill in my refund original case details'
  step 'I fill in my refund fees and verify the total'
  step 'I fill in my refund bank details'
  step 'I accept the refund final declaration'
end

And(/^I fill in the refund forms$/) do
  step 'I fill in my refund applicant details'
  step 'I fill in my refund original case details'
  step 'I fill in my refund fees and verify the total'
  step 'I fill in my refund bank details'
end
