And(/^I answer "Unfair dismissal \(including constructive dismissal\)" to the about the claim question$/) do
  step_eight_page.claim_type.set("Unfair dismissal (including constructive dismissal)")
end

And(/^I fill in my claim type details for my employment tribunal$/) do
  test_user.et_case.claim_types.each_pair do |key, value|
    step_eight_page.claim_type.set(key) if value
  end
end



And(/^I answer Yes to the whistleblowing claim question$/) do
  step_eight_page.whistleblowing_claim.set("Yes")
end

And(/^I answer Yes to the send copy to relevant person that deals with whistleblowing question$/) do
  step_eight_page.whistleblowing_claim.send_to_relevant_person.set("Yes")
end

And(/^I save the claim type$/) do
  step_eight_page.save_and_continue.click
end


And(/^I fill in my whistleblowing details for my employment tribunal$/) do
  step_eight_page.whistleblowing_claim.set(test_user.et_case.whistleblowing_claim)
  step_eight_page.whistleblowing_claim.send_to_relevant_person.set(test_user.et_case.send_whistleblowing_claim_to_relevant_person)
end
