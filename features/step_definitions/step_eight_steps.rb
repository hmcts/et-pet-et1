And(/^I answer "Unfair dismissal \(including constructive dismissal\)" to the about the claim question$/) do
  step_eight_page.claim_type.set("Unfair dismissal (including constructive dismissal)")
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
