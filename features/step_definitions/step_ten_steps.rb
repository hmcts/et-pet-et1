And(/^I answer "([^"]*)" to the preferred outcome question$/) do |value|
  step_ten_page.preferred_outcome.set(value)
end

And(/^I fill in the compensation field with "([^"]*)"$/) do |value|
  step_ten_page.preferred_outcome.notes.set(value)
end

And(/^I save the claim outcome$/) do
  step_ten_page.save_and_continue.click
end


And(/^I fill in my preferred outcomes for my employee tribunal$/) do
  if test_user.et_case.preferred_outcomes.present?
    test_user.et_case.preferred_outcomes.each do |outcome|
      step_ten_page.preferred_outcome.set(outcome)
    end
  end
  step_ten_page.preferred_outcome.notes.set(test_user.et_case.preferred_outcome_notes)
end
