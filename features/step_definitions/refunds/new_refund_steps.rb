Given(/^I am on the landing page$/) do
  new_claim_page.load
end


And(/^I start a new refund$/) do
  new_claim_page.start_a_refund.click
end
