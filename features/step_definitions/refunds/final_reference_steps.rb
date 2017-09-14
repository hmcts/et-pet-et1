Then(/^I should see a valid refund reference number starting with "([^"]*)"$/) do |arg|
  expect(refund_confirmation_page.reference_number.text).to start_with(arg)
  expect(refund_confirmation_page.reference_number.text).to match(/(C|R)\d\d\d\d\d\d/)
end
