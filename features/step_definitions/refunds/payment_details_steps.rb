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

And(/^I fill in my refund building society details with:$/) do |table|
  table.hashes.each do |hash|
    refund_payment_details_page.building_society_details do |section|
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
    refund_payment_details_page.account_type.select('Bank')
    refund_payment_details_page.bank_details do |section|
      section.account_name.set(test_user.bank_account.account_name)
      section.bank_name.set(test_user.bank_account.bank_name)
      section.account_number.set(test_user.bank_account.account_number)
      section.sort_code.set(test_user.bank_account.sort_code)
    end
  elsif test_user.building_society_account.present?
    refund_payment_details_page.account_type.select('Building Society')
    refund_payment_details_page.building_society_details do |section|
      section.account_name.set(test_user.building_society_account.account_name)
      section.building_society_name.set(test_user.building_society_account.building_society_name)
      section.account_number.set(test_user.building_society_account.account_number)
      section.sort_code.set(test_user.building_society_account.sort_code)
    end
  else
    raise "No bank or building society details present in the test_user"
  end

  refund_payment_details_page.save_and_continue.click

end

Then(/^I should see the refund bank details page$/) do
  expect(refund_payment_details_page).to be_displayed
end

Then(/^all mandatory bank details fields should be marked with an error$/) do
  aggregate_failures do
    expect(refund_payment_details_page.bank_details.account_name.error.text).to eql "Enter Account holder name"
    expect(refund_payment_details_page.bank_details.bank_name.error.text).to eql "Enter Bank name"
    expect(refund_payment_details_page.bank_details.account_number.error.text).to eql "Enter Bank account"
    expect(refund_payment_details_page.bank_details.sort_code.error.text).to eql "Enter Sort Code"
    expect(refund_payment_details_page).to have_no_building_society_details
  end
end

Then(/^all mandatory building society details fields should be marked with an error$/) do
  aggregate_failures do
    expect(refund_payment_details_page.building_society_details.account_name.error.text).to eql "Enter the name on the building society account"
    expect(refund_payment_details_page.building_society_details.building_society_name.error.text).to eql "Enter the name of the building society"
    expect(refund_payment_details_page.building_society_details.account_number.error.text).to eql "Enter the account number that the refund is to be paid into"
    expect(refund_payment_details_page.building_society_details.sort_code.error.text).to eql "Enter the sort code of the account that the refund is to be paid into"
    expect(refund_payment_details_page).to have_no_bank_details
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
  expect(refund_payment_details_page.building_society_details.account_name).to have_no_error
  expect(refund_payment_details_page.building_society_details.building_society_name).to have_no_error
  expect(refund_payment_details_page.building_society_details.account_number).to have_no_error
  expect(refund_payment_details_page.building_society_details.sort_code).to have_no_error

end

Then(/^the continue button should be disabled on the bank details page$/) do
  expect(refund_payment_details_page.save_and_continue).to be_disabled
end

Then(/^the bank account number field should be marked with an invalid error in the refund bank details page$/) do
  expect(refund_payment_details_page.bank_details.account_number.error.text).to eql "Must be 8 numbers"
end

Then(/^the bank sort code field should be marked with an invalid error in the refund bank details page$/) do
  expect(refund_payment_details_page.bank_details.sort_code.error.text).to eql "Must be 6 numbers"
end

Then(/^the building society account number field should be marked with an invalid error in the refund bank details page$/) do
  expect(refund_payment_details_page.building_society_details.account_number.error.text).to eql "Must be 8 numbers"
end

Then(/^the building society sort code field should be marked with an invalid error in the refund bank details page$/) do
  expect(refund_payment_details_page.building_society_details.sort_code.error.text).to eql "Must be 6 numbers"
end
