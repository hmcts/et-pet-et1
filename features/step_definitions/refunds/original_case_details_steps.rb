And(/^I fill in my refund original case details with:$/) do |table|
  table.hashes.each do |hash|
    refund_original_case_details_page.original_case_details do |section|
      node = section.send(hash['field'].to_sym)
      case node.try(:tag_name)
      when "select" then node.select(hash['value'])
      else node.set(hash['value'])
      end
    end
  end
end

And(/^I fill in my refund original case details respondent details with:$/) do |table|
  table.hashes.each do |hash|
    refund_original_case_details_page.original_respondent_details do |section|
      node = section.send(hash['field'].to_sym)
      case node.try(:tag_name)
      when "select" then node.select(hash['value'])
      else node.set(hash['value'])
      end
    end
  end
end

And(/^I fill in my refund original case details representative details with:$/) do |table|
  table.hashes.each do |hash|
    refund_original_case_details_page.original_representative_details do |section|
      node = section.send(hash['field'].to_sym)
      case node.try(:tag_name)
      when "select" then node.select(hash['value'])
      else node.set(hash['value'])
      end
    end
  end
end

And(/^I fill in my refund issue fee with:$/) do |table|
  table.hashes.each do |hash|
    refund_original_case_details_page.original_claim_fees.et_issue do |section|
      section.fee.set(hash['fee'])
      section.payment_method.select(hash['payment method'])
    end
  end
end

And(/^I fill in my refund hearing fee with:$/) do |table|
  table.hashes.each do |hash|
    refund_original_case_details_page.original_claim_fees.et_hearing do |section|
      section.fee.set(hash['fee'])
      section.payment_method.select(hash['payment method'])
    end
  end
end

And(/^I fill in my refund eat issue fee with:$/) do |table|
  table.hashes.each do |hash|
    refund_original_case_details_page.original_claim_fees.eat_issue do |section|
      section.fee.set(hash['fee'])
      section.payment_method.select(hash['payment method'])
    end
  end
end

And(/^I fill in my refund eat hearing fee with:$/) do |table|
  table.hashes.each do |hash|
    refund_original_case_details_page.original_claim_fees.eat_hearing do |section|
      section.fee.set(hash['fee'])
      section.payment_method.select(hash['payment method'])
    end
  end
end

And(/^I fill in my refund application reconsideration fee with:$/) do |table|
  table.hashes.each do |hash|
    refund_original_case_details_page.original_claim_fees.et_reconsideration do |section|
      section.fee.set(hash['fee'])
      section.payment_method.select(hash['payment method'])
    end
  end
end

And(/^I answer (Yes|No) to the has your address changed question for refunds$/) do |arg|
  refund_original_case_details_page.address_changed.set(arg)
end

And(/^I save the refund case details$/) do
  refund_original_case_details_page.save_and_continue.click
end

And(/^I fill in my refund original case details$/) do
  step('I take a screenshot named "Page 3 - Original Case Details 1 "')
  refund_original_case_details_page.address_changed.set(test_user.claim_address_changed) unless test_user.claim_address_changed.nil?
  if test_user.claim_address_changed == 'Yes'
    refund_original_case_details_page.original_claimant_details do |section|
      section.building.set(test_user.et_claim_to_refund.address.building)
      section.street.set(test_user.et_claim_to_refund.address.street)
      section.locality.set(test_user.et_claim_to_refund.address.locality)
      section.county.set(test_user.et_claim_to_refund.address.county)
      section.post_code.set(test_user.et_claim_to_refund.address.post_code)
    end
  end
  step('I take a screenshot named "Page 3 - Original Case Details 2 "')
  refund_original_case_details_page.original_case_details do |section|
    section.et_country_of_claim.set(test_user.et_claim_to_refund.et_country_of_claim) unless test_user.et_claim_to_refund.et_country_of_claim.nil?
    section.et_case_number.set(test_user.et_claim_to_refund.et_case_number) unless test_user.et_claim_to_refund.et_case_number.nil?
    section.eat_case_number.set(test_user.et_claim_to_refund.eat_case_number) unless test_user.et_claim_to_refund.eat_case_number.nil?
    section.et_tribunal_office.set(test_user.et_claim_to_refund.et_tribunal_office) unless test_user.et_claim_to_refund.et_tribunal_office.nil?
    section.additional_information.set(test_user.et_claim_to_refund.additional_information) unless test_user.et_claim_to_refund.additional_information.nil?
  end
  step('I take a screenshot named "Page 3 - Original Case Details 3 "')
  refund_original_case_details_page.original_respondent_details do |section|
    section.name.set(test_user.et_claim_to_refund.respondent.name)
    section.building.set(test_user.et_claim_to_refund.respondent.address.building)
    section.street.set(test_user.et_claim_to_refund.respondent.address.street)
    section.locality.set(test_user.et_claim_to_refund.respondent.address.locality)
    section.county.set(test_user.et_claim_to_refund.respondent.address.county)
    section.post_code.set(test_user.et_claim_to_refund.respondent.address.post_code)
  end
  step('I take a screenshot named "Page 3 - Original Case Details 4 "')

  refund_original_case_details_page.claim_had_representative.set(test_user.et_claim_to_refund.has_representative) unless test_user.et_claim_to_refund.has_representative.nil?
  if test_user.et_claim_to_refund.has_representative == 'Yes'
    refund_original_case_details_page.original_representative_details do |section|
      section.name.set(test_user.et_claim_to_refund.representative.name)
      section.building.set(test_user.et_claim_to_refund.representative.address.building)
      section.street.set(test_user.et_claim_to_refund.representative.address.street)
      section.locality.set(test_user.et_claim_to_refund.representative.address.locality)
      section.county.set(test_user.et_claim_to_refund.representative.address.county)
      section.post_code.set(test_user.et_claim_to_refund.representative.address.post_code)
    end
  end
  step('I take a screenshot named "Page 3 - Original Case Details 5 "')
  refund_original_case_details_page.save_and_continue.click

end

Then(/^all mandatory claimant address fields in the refund case details should be marked with an error$/) do
  aggregate_failures do
    expect(refund_original_case_details_page.original_claimant_details.building.error.text).to eql "Enter the building number or name from your address at the time of the original claim"
    expect(refund_original_case_details_page.original_claimant_details.street.error.text).to eql "Enter the street from your address at the time of the original claim"
    expect(refund_original_case_details_page.original_claimant_details.post_code.error.text).to eql "Enter your post code at the time of the original claim"
    expect(refund_original_case_details_page.original_claimant_details.locality).to have_no_error, 'Expected claimant locality not to have an error'
    expect(refund_original_case_details_page.original_claimant_details.county).to have_no_error, 'Expected claimant county not to have an error'
  end
end

And(/^all mandatory respondent address fields in the refund case details should be marked with an error$/) do
  aggregate_failures do
    expect(refund_original_case_details_page.original_respondent_details.name.error.text).to eql "Enter the respondent's name"
    expect(refund_original_case_details_page.original_respondent_details.building.error.text).to eql "Enter the building number or name from the respondent's address"
    expect(refund_original_case_details_page.original_respondent_details.street.error.text).to eql "Enter the street from the respondent's address"
    expect(refund_original_case_details_page.original_respondent_details.locality).to have_no_error, 'Expected respondent locality not to have an error'
    expect(refund_original_case_details_page.original_respondent_details.post_code).to have_no_error, 'Expected respondent post code not to have an error'
    expect(refund_original_case_details_page.original_respondent_details.county).to have_no_error, 'Expected respondent county not to have an error'
  end
end

And(/^all mandatory representative address fields in the refund case details should be marked with an error$/) do
  aggregate_failures do
    expect(refund_original_case_details_page.original_representative_details.name.error.text).to eql "Enter the representative's name"
    expect(refund_original_case_details_page.original_representative_details.building.error.text).to eql "Enter the building number or name from the representative's address"
    expect(refund_original_case_details_page.original_representative_details.street.error.text).to eql "Enter the street from the representative's address"
    expect(refund_original_case_details_page.original_representative_details.post_code.error.text).to eql "Enter the representative's post code"
    expect(refund_original_case_details_page.original_representative_details.locality).to have_no_error, 'Expected rep locality not to have an error'
    expect(refund_original_case_details_page.original_representative_details.county).to have_no_error, 'Expected rep county not to have an error'
  end
end

And(/^the had representative field in the refunds case details should be marked with an error$/) do
  expect(refund_original_case_details_page.claim_had_representative.error.text).to eql "Please select Yes or No"
end

And(/^the country of claim field in the refunds case details should be marked with an error$/) do
  expect(refund_original_case_details_page.original_case_details.et_country_of_claim.error.text).to eql "Please select the country where your case was heard"
end

And(/^I answer (Yes|No) to the had representative question for refunds$/) do |had_representative|
  refund_original_case_details_page.claim_had_representative.set(had_representative)
end

And(/^all mandatory case details fields in the refund case details should be marked with an error$/) do
  aggregate_failures do
    expect(refund_original_case_details_page.original_case_details.et_country_of_claim.error.text).to eql "Please select the country where your case was heard"
    expect(refund_original_case_details_page.original_case_details.et_case_number).to have_no_error
    expect(refund_original_case_details_page.original_case_details.eat_case_number).to have_no_error
    expect(refund_original_case_details_page.original_case_details.et_tribunal_office).to have_no_error
    expect(refund_original_case_details_page.original_case_details.additional_information).to have_no_error
  end
end

Then(/^I should see the following errors in the case details section of the refund case details step:$/) do |table|
  # table is a table.hashes.keys # => [:field, :error]
  table.hashes.each do |hash|
    expect(refund_original_case_details_page.original_case_details.send(hash['field'].to_sym).error.text).to eql hash['error']
  end
end

And(/^I enter (\d+) characters into the additional information field in the refund case details$/) do |length|
  str = "a" * length.to_i
  refund_original_case_details_page.original_case_details.additional_information.set(str)
end

Then(/^I should see (\d+) characters in the additional information field in the refund case details$/) do |length|
  expect(refund_original_case_details_page.original_case_details.additional_information.get.length).to eql length.to_i
end
