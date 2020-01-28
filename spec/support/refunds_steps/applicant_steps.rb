def when_i_answer_yes_to_the_has_your_name_changed_question_for_refunds
  refund_applicant_page.has_name_changed.set('Yes')
end
def when_i_answer_no_to_the_has_your_name_changed_question_for_refunds
  refund_applicant_page.has_name_changed.set('No')
end

def and_i_fill_in_my_refund_claimant_details_with(table_hashes)
  # table is a table.hashes.keys # => [:field, :value]
  table_hashes.each do |hash|
    refund_applicant_page.about_the_claimant do |section|
      node = section.send(hash[:field].to_sym)
      case node.try(:tag_name)
      when "select" then node.select(hash[:value])
      else node.set(hash[:value])
      end
    end
  end

end

def and_i_fill_in_my_refund_claimant_contact_details_with(table_hashes)
  # table is a table.hashes.keys # => [:field, :value]
  table_hashes.each do |hash|
    refund_applicant_page.claimants_contact_details do |section|
      node = section.send(hash[:field].to_sym)
      case node.try(:tag_name)
      when "select" then node.select(hash[:value])
      else node.set(hash[:value])
      end
    end
  end
end

def and_i_save_the_refund_applicant_details
  refund_applicant_page.save_and_continue.click
end

def then_the_user_should_be_informed_that_there_are_errors_on_the_refund_applicant_page
  expect(refund_applicant_page.form_error_message).to be_visible
end

def and_all_mandatory_fields_in_the_refund_applicant_page_should_be_marked_with_an_error
  aggregate_failures do
    expect(refund_applicant_page.about_the_claimant.title.error.text).to eql "Select a title from the list"
    expect(refund_applicant_page.about_the_claimant.first_name.error.text).to eql "Enter your first name"
    expect(refund_applicant_page.about_the_claimant.last_name.error.text).to eql "Enter your last name"
    expect(refund_applicant_page.about_the_claimant.date_of_birth.error.text).to eql "Enter your date of birth"
    expect(refund_applicant_page.claimants_contact_details.building.error.text).to eql "Enter the building number or name from your address"
    expect(refund_applicant_page.claimants_contact_details.street.error.text).to eql "Enter the street from your address"
    expect(refund_applicant_page.claimants_contact_details.locality.error.text).to eql "Enter the town or city from the claimant’s address"
    expect(refund_applicant_page.claimants_contact_details.post_code.error.text).to eql "Enter your post code"
    expect(refund_applicant_page.claimants_contact_details.telephone_number.error.text).to eql "Enter your preferred number"

    expect(refund_applicant_page.claimants_contact_details.county).to have_no_error, 'Expected county not to have an error'
    expect(refund_applicant_page.claimants_contact_details.email_address).to have_no_error, 'Expected email address not to have an error'
  end
end

def and_i_fill_in_my_refund_applicant_details
  refund_applicant_page.has_name_changed.set(test_user.has_name_changed) unless test_user.has_name_changed.nil?
  refund_applicant_page.about_the_claimant do |section|
    section.title.set(test_user.title)
    section.first_name.set(test_user.first_name)
    section.last_name.set(test_user.last_name)
    section.date_of_birth.set(test_user.date_of_birth)
  end
  refund_applicant_page.claimants_contact_details do |section|
    section.building.set(test_user.address.building) unless test_user.address.building.nil?
    section.street.set(test_user.address.street) unless test_user.address.street.nil?
    section.locality.set(test_user.address.locality) unless test_user.address.locality.nil?
    section.county.set(test_user.address.county) unless test_user.address.county.nil?
    section.post_code.set(test_user.address.post_code) unless test_user.address.post_code.nil?
    section.telephone_number.set(test_user.telephone_number) unless test_user.telephone_number.nil?
    section.email_address.set(test_user.email_address) unless test_user.email_address.nil?
  end
  and_i_save_the_refund_applicant_details
end

def then_the_continue_button_should_be_disabled_on_the_refund_applicant_page
  expect(refund_applicant_page.save_and_continue).to be_disabled
end

def and_the_email_address_in_the_refund_applicant_page_should_be_marked_with_an_invalid_error
  expect(refund_applicant_page.claimants_contact_details.email_address.error.text).to eql 'is invalid'
end

def and_the_date_of_birth_in_the_refund_applicant_page_should_be_marked_with_an_invalid_error
  expect(refund_applicant_page.about_the_claimant.date_of_birth.error.text).to eql 'is invalid'
end

def then_the_title_field_in_the_applicant_page_should_have_the_correct_default_option_selected
  expect(refund_applicant_page.about_the_claimant.title.get).to eql 'Please select'
end
