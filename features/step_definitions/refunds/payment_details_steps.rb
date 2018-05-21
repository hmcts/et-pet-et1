And(/^I fill in my refund bank details with:$/) do |table|
  table.hashes.each do |hash|
    refund_payment_details_page.bank_details do |section|
      node = section.send(hash['field'].to_sym)
      case node.try(:tag_name)
      when "select" then node.select(hash['value'])
      else node.set(hash['value'])
      end
    end
  end
end

And(/^I save the refund bank details$/) do
  refund_payment_details_page.save_and_continue.click
end

And(/^I fill in my refund bank details$/) do
  if test_user.bank_account.present?
    refund_payment_details_page.bank_details do |section|
      section.account_name.set(test_user.bank_account.account_name)
      section.bank_name.set(test_user.bank_account.bank_name)
      section.account_number.set(test_user.bank_account.account_number)
      section.sort_code.set(test_user.bank_account.sort_code)
    end
  else
    raise "No bank details present in the test_user"
  end
  step('I take a screenshot named "Page 5 - Bank Account Details"')
  refund_payment_details_page.save_and_continue.click

end

Then(/^I should see the refund bank details page$/) do
  expect(refund_payment_details_page).to be_displayed
end

Then(/^all mandatory bank details fields should be marked with an error$/) do
  aggregate_failures do
    expect(refund_payment_details_page.bank_details.account_name.error.text).to eql "Enter Account Name"
    expect(refund_payment_details_page.bank_details.bank_name.error.text).to eql "Enter Bank/Building Society name"
    expect(refund_payment_details_page.bank_details.account_number.error.text).to eql "Enter Account number"
    expect(refund_payment_details_page.bank_details.sort_code.error.text).to eql "Enter Sort Code"
  end
end

And(/^I select "([^"]*)" account type in the refund bank details page$/) do |account_type|
  refund_payment_details_page.account_type.select(account_type)
end

Then(/^only the bank details account type field should be marked with an error$/) do
  expect(refund_payment_details_page.account_type.error.text).to eql "Please select one of the options"
  expect(refund_payment_details_page.bank_details.account_name).to have_no_error
  expect(refund_payment_details_page.bank_details.bank_name).to have_no_error
  expect(refund_payment_details_page.bank_details.account_number).to have_no_error
  expect(refund_payment_details_page.bank_details.sort_code).to have_no_error
end

Then(/^the bank account number field should be marked with an invalid error in the refund bank details page$/) do
  expect(refund_payment_details_page.bank_details.account_number.error.text).to eql "Must be 8 numbers"
end

Then(/^the bank sort code field should be marked with an invalid error in the refund bank details page$/) do
  expect(refund_payment_details_page.bank_details.sort_code.error.text).to eql "Must be 6 numbers"
end
