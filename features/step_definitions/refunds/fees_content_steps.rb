Then(/^all fee help content should be correct on the fees page$/) do
  expect(refund_fees_page).to have_valid_help_section
end
