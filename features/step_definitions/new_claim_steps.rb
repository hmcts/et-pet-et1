Given(/^I am on the new claim page$/) do
  new_claim_page.load
end


And(/^I start a new claim$/) do
  new_claim_page.start_a_claim.click
end
