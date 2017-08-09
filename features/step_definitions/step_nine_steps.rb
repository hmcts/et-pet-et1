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
