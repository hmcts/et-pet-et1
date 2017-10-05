And(/^I accept the refund final declaration$/) do
  refund_review_page.declaration.set("Yes")
  step('I take a screenshot named "Page 6 - Review"')
  refund_review_page.save_and_continue.click
end

And(/^I save the final refund$/) do
  refund_review_page.save_and_continue.click
end

And(/^I verify the claimant section of the refund review page$/) do
  refund_review_page.about_the_claimant do |section|
    expect(section.full_name.text).to eql "#{test_user.title} #{test_user.first_name} #{test_user.last_name}"
    expect(section.date_of_birth.text).to eql Date.parse(test_user.date_of_birth).strftime('%d/%m/%Y')
  end

end

And(/^I verify the claimants contact details of the refund review page$/) do
  refund_review_page.claimants_contact_details do |section|
    expect(section.building.text).to eql test_user.address.building.to_s
    expect(section.street.text).to eql test_user.address.street.to_s
    expect(section.locality.text).to eql test_user.address.locality.to_s
    expect(section.county.text).to eql test_user.address.county.to_s
    expect(section.post_code.text).to eql test_user.address.post_code.to_s
    expect(section.telephone_number.text).to eql test_user.telephone_number.to_s
    expect(section.email_address.text).to eql test_user.email_address.to_s
  end
end

And(/^I verify the claimants name and address in the original case details of the refund review page$/) do
  refund_review_page.original_claimant_details do |section|
    expect(section.name.text).to eql "#{test_user.title} #{test_user.first_name} #{test_user.last_name}"
    expect(section.building.text).to eql test_user.et_claim_to_refund.address.building.to_s
    expect(section.street.text).to eql test_user.et_claim_to_refund.address.street.to_s
    expect(section.locality.text).to eql test_user.et_claim_to_refund.address.locality.to_s
    expect(section.county.text).to eql test_user.et_claim_to_refund.address.county.to_s
    expect(section.post_code.text).to eql test_user.et_claim_to_refund.address.post_code.to_s
  end
end

And(/^I verify the case details in the case details of the refund review page$/) do
  refund_review_page.original_case_details do |section|
    expect(section.et_country_of_claim.text).to eql test_user.et_claim_to_refund.et_country_of_claim.to_s
    expect(section.et_case_number.text).to eql test_user.et_claim_to_refund.et_case_number.to_s
    expect(section.eat_case_number.text).to eql test_user.et_claim_to_refund.eat_case_number.to_s
    expect(section.et_tribunal_office.text).to eql test_user.et_claim_to_refund.et_tribunal_office.to_s
    expect(section.additional_information.text).to eql test_user.et_claim_to_refund.additional_information.to_s
  end
end

And(/^I verify the respondent details in the case details of the refund review page$/) do
  refund_review_page.original_respondent_details do |section|
    expect(section.name.text).to eql test_user.et_claim_to_refund.respondent.name.to_s
    expect(section.building.text).to eql test_user.et_claim_to_refund.respondent.address.building.to_s
    expect(section.street.text).to eql test_user.et_claim_to_refund.respondent.address.street.to_s
    expect(section.locality.text).to eql test_user.et_claim_to_refund.respondent.address.locality.to_s
    expect(section.county.text).to eql test_user.et_claim_to_refund.respondent.address.county.to_s
    expect(section.post_code.text).to eql test_user.et_claim_to_refund.respondent.address.post_code.to_s
  end
end

And(/^I verify the representative details in the case details of the refund review page/) do
  refund_review_page.original_representative_details do |section|
    expect(section.name.text).to eql test_user.et_claim_to_refund.representative.name.to_s
    expect(section.building.text).to eql test_user.et_claim_to_refund.representative.address.building.to_s
    expect(section.street.text).to eql test_user.et_claim_to_refund.representative.address.street.to_s
    expect(section.locality.text).to eql test_user.et_claim_to_refund.representative.address.locality.to_s
    expect(section.county.text).to eql test_user.et_claim_to_refund.representative.address.county.to_s
    expect(section.post_code.text).to eql test_user.et_claim_to_refund.representative.address.post_code.to_s
  end
end

And(/I verify the fees in the case details of the refund review page$/) do
  aggregate_failures do
    fees = test_user.et_claim_to_refund.fees
    if fees.et_issue_fee.present?
      refund_review_page.original_claim_fees.et_issue do |section|
        expect(section.fee.text).to eql "£#{fees.et_issue_fee}"
        expect(section.payment_method.text).to eql fees.et_issue_payment_method.to_s
        expect(section.payment_date.text).to eql fees.et_issue_payment_date.to_s
      end
    else
      expect(refund_review_page.original_claim_fees).to have_no_et_issue
    end
    if fees.et_hearing_fee.present?
      refund_review_page.original_claim_fees.et_hearing do |section|
        expect(section.fee.text).to eql "£#{fees.et_hearing_fee}"
        expect(section.payment_method.text).to eql fees.et_hearing_payment_method.to_s
        expect(section.payment_date.text).to eql fees.et_hearing_payment_date.to_s
      end
    else
      expect(refund_review_page.original_claim_fees).to have_no_et_hearing
    end
    if fees.et_reconsideration_fee.present?
      refund_review_page.original_claim_fees.et_reconsideration do |section|
        expect(section.fee.text).to eql "£#{fees.et_reconsideration_fee}"
        expect(section.payment_method.text).to eql fees.et_reconsideration_payment_method.to_s
        expect(section.payment_date.text).to eql fees.et_reconsideration_payment_date.to_s
      end
    else
      expect(refund_review_page.original_claim_fees).to have_no_et_reconsideration
    end
    if fees.eat_issue_fee.present?
      refund_review_page.original_claim_fees.eat_issue do |section|
        expect(section.fee.text).to eql "£#{fees.eat_issue_fee}"
        expect(section.payment_method.text).to eql fees.eat_issue_payment_method.to_s
        expect(section.payment_date.text).to eql fees.eat_issue_payment_date.to_s
      end
    else
      expect(refund_review_page.original_claim_fees).to have_no_eat_issue
    end
    if fees.eat_hearing_fee.present?
      refund_review_page.original_claim_fees.eat_hearing do |section|
        expect(section.fee.text).to eql "£#{fees.eat_hearing_fee}"
        expect(section.payment_method.text).to eql fees.eat_hearing_payment_method.to_s
        expect(section.payment_date.text).to eql fees.eat_hearing_payment_date.to_s
      end
    else
      expect(refund_review_page.original_claim_fees).to have_no_eat_hearing
    end
    expected_total = [:et_issue, :et_hearing, :et_reconsideration, :eat_issue, :eat_hearing].reduce(0.0) do |t, fee|
      fee_value = fees.send("#{fee}_fee".to_sym)
      next t if fee_value.nil?
      t + fee_value.to_f
    end
    if expected_total > 0.0
      total_value = refund_review_page.original_claim_fees.total.fee.text.gsub(/£/, '').to_f
      expect(total_value).to eql expected_total
    else
      expect(refund_review_page.original_claim_fees).to have_empty_fees
    end
  end
end

And(/^I verify the representative details are not present in the case details of the refund review page$/) do
  aggregate_failures do
    refund_review_page.original_representative_details do |section|
      expect(section).to have_no_name
      expect(section).to have_no_building
      expect(section).to have_no_street
      expect(section).to have_no_locality
      expect(section).to have_no_county
      expect(section).to have_no_post_code
    end
  end
end

And(/^I verify the bank details in the bank details of the refund review page$/) do
  refund_review_page.bank_details do |section|
    expect(section.account_name.text).to eql test_user.bank_account.account_name
    expect(section.bank_name.text).to eql test_user.bank_account.bank_name
    expect(section.account_number.text).to eql test_user.bank_account.account_number
    expect(section.sort_code.text).to eql test_user.bank_account.sort_code
  end
end

And(/^I verify the building society details in the bank details of the refund review page$/) do
  refund_review_page.building_society_details do |section|
    expect(section.account_name.text).to eql test_user.building_society_account.account_name
    expect(section.building_society_name.text).to eql test_user.building_society_account.building_society_name
    expect(section.account_number.text).to eql test_user.building_society_account.account_number
    expect(section.sort_code.text).to eql test_user.building_society_account.sort_code
  end
end

And(/^I verify the bank details are not present in the bank details of the review page$/) do
  expect(refund_review_page).to have_no_bank_details
end

And(/^I verify the building society details are not present in the bank details of the refund review page$/) do
  expect(refund_review_page).to have_no_building_society_details
end

And(/^I verify the review page and accept the declaration$/) do
  step 'I verify the claimant section of the refund review page'
  step 'I verify the claimants contact details of the refund review page'
  step 'I verify the claimants name and address in the original case details of the refund review page'
  step 'I verify the case details in the case details of the refund review page'
  step 'I verify the respondent details in the case details of the refund review page'
  step 'I verify the representative details in the case details of the refund review page' if test_user.et_claim_to_refund.has_representative == 'Yes'
  step 'I verify the representative details are not present in the case details of the refund review page' unless test_user.et_claim_to_refund.has_representative == 'Yes'
  step 'I verify the fees in the case details of the refund review page'
  step 'I verify the bank details in the bank details of the refund review page' if test_user.bank_account.present?
  step 'I verify the bank details are not present in the bank details of the review page' if test_user.bank_account.blank?
  step 'I verify the building society details in the bank details of the refund review page' if test_user.building_society_account.present?
  step 'I verify the building society details are not present in the bank details of the refund review page' if test_user.building_society_account.blank?
  step 'I accept the refund final declaration'
end

Then(/^the continue button should be disabled on the review page$/) do
  expect(refund_review_page.save_and_continue).to be_disabled
end
