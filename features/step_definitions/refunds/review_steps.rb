And(/^I accept the refund final declaration$/) do
  refund_review_page.declaration.set("Yes")
  step('I take a screenshot named "Page 5 - Review"')
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
    expect(section.building.text).to eql test_user.address.building
    expect(section.street.text).to eql test_user.address.street
    expect(section.locality.text).to eql test_user.address.locality
    expect(section.county.text).to eql test_user.address.county
    expect(section.post_code.text).to eql test_user.address.post_code
    expect(section.telephone_number.text).to eql test_user.telephone_number
    expect(section.email_address.text).to eql test_user.email_address
  end
end

And(/^I verify the claimants name and address in the original case details of the refund review page$/) do
  refund_review_page.original_claimant_details do |section|
    expect(section.name.text).to eql "#{test_user.title} #{test_user.first_name} #{test_user.last_name}"
    expect(section.building.text).to eql test_user.et_claim_to_refund.address.building
    expect(section.street.text).to eql test_user.et_claim_to_refund.address.street
    expect(section.locality.text).to eql test_user.et_claim_to_refund.address.locality
    expect(section.county.text).to eql test_user.et_claim_to_refund.address.county
    expect(section.post_code.text).to eql test_user.et_claim_to_refund.address.post_code
  end
end

And(/^I verify the case details in the case details of the refund review page$/) do
  refund_review_page.original_case_details do |section|
    expect(section.et_country_of_claim.text).to eql test_user.et_claim_to_refund.et_country_of_claim
    expect(section.et_case_number.text).to eql test_user.et_claim_to_refund.et_case_number
    expect(section.et_tribunal_office.text).to eql test_user.et_claim_to_refund.et_tribunal_office
    expect(section.additional_information.text).to eql test_user.et_claim_to_refund.additional_information
  end
end

And(/^I verify the respondent details in the case details of the refund review page$/) do
  refund_review_page.original_respondent_details do |section|
    expect(section.name.text).to eql test_user.et_claim_to_refund.respondent.name
    expect(section.building.text).to eql test_user.et_claim_to_refund.respondent.address.building
    expect(section.street.text).to eql test_user.et_claim_to_refund.respondent.address.street
    expect(section.locality.text).to eql test_user.et_claim_to_refund.respondent.address.locality
    expect(section.county.text).to eql test_user.et_claim_to_refund.respondent.address.county
    expect(section.post_code.text).to eql test_user.et_claim_to_refund.respondent.address.post_code
  end
end

And(/^I verify the representative details in the case details of the refund review page/) do
  refund_review_page.original_representative_details do |section|
    expect(section.name.text).to eql test_user.et_claim_to_refund.representative.name
    expect(section.building.text).to eql test_user.et_claim_to_refund.representative.address.building
    expect(section.street.text).to eql test_user.et_claim_to_refund.representative.address.street
    expect(section.locality.text).to eql test_user.et_claim_to_refund.representative.address.locality
    expect(section.county.text).to eql test_user.et_claim_to_refund.representative.address.county
    expect(section.post_code.text).to eql test_user.et_claim_to_refund.representative.address.post_code
  end
end

And(/I verify the fees in the case details of the refund review page$/) do
  aggregate_failures do
    refund_review_page.original_claim_fees.et_issue do |section|
      expect(section.fee.text).to eql "£#{test_user.et_claim_to_refund.fees.et_issue_fee}"
      expect(section.payment_method.text).to eql test_user.et_claim_to_refund.fees.et_issue_payment_method
    end
    refund_review_page.original_claim_fees.et_hearing do |section|
      expect(section.fee.text).to eql "£#{test_user.et_claim_to_refund.fees.et_hearing_fee}"
      expect(section.payment_method.text).to eql test_user.et_claim_to_refund.fees.et_hearing_payment_method
    end
    refund_review_page.original_claim_fees.et_reconsideration do |section|
      expect(section.fee.text).to eql "£#{test_user.et_claim_to_refund.fees.et_reconsideration_fee}"
      expect(section.payment_method.text).to eql test_user.et_claim_to_refund.fees.et_reconsideration_payment_method
    end
    refund_review_page.original_claim_fees.eat_issue do |section|
      expect(section.fee.text).to eql "£#{test_user.et_claim_to_refund.fees.eat_issue_fee}"
      expect(section.payment_method.text).to eql test_user.et_claim_to_refund.fees.eat_issue_payment_method
    end
    refund_review_page.original_claim_fees.eat_hearing do |section|
      expect(section.fee.text).to eql "£#{test_user.et_claim_to_refund.fees.eat_hearing_fee}"
      expect(section.payment_method.text).to eql test_user.et_claim_to_refund.fees.eat_hearing_payment_method
    end
  end
end

And(/^I verify the representative details are not present$/) do
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

And(/^I verify the review page and accept the declaration$/) do
  step 'I verify the claimant section of the refund review page'
  step 'I verify the claimants contact details of the refund review page'
  step 'I verify the claimants name and address in the original case details of the refund review page'
  step 'I verify the case details in the case details of the refund review page'
  step 'I verify the respondent details in the case details of the refund review page'
  step 'I verify the representative details in the case details of the refund review page' if test_user.et_claim_to_refund.has_representative == 'Yes'
  step 'I verify the representative details are not present' unless test_user.et_claim_to_refund.has_representative == 'Yes'
  step 'I verify the fees in the case details of the refund review page'
  step 'I accept the refund final declaration'
end
