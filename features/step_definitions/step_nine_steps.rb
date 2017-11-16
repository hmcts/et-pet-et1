And(/^I fill in the claim description with "([^"]*)"$/) do |description|
  step_nine_page.description.set(description)
end

And(/^I answer Yes to the similar claims question$/) do
  step_nine_page.similar_claims.other_claimants.set('Yes')
end

And(/^I fill in the similar claim names with "([^"]*)"$/) do |text|
  step_nine_page.similar_claims.names.set(text)
end

And(/^I save the claim details$/) do
  step_nine_page.save_and_continue.click
end


And(/^I fill in my claim details for my employment tribunal$/) do
  step_nine_page.description.set(test_user.et_case.claim_description)
  if test_user.et_case.similar_claims.present?
    step_nine_page.similar_claims.other_claimants.set('Yes')
    step_nine_page.similar_claims.names.set(test_user.et_case.similar_claims.join(', '))
  end
end
