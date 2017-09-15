And(/^I answer Yes to the are you the claimant question for refunds$/) do
  refund_step_two_page.is_claimant.set("Yes")
end


And(/^I answer (Yes|No) to the has your name changed question for refunds$/) do |value|
  refund_step_two_page.has_name_changed.set(value)
end

And(/^I fill in my refund claimant details with:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  table.hashes.each do | hash |
    refund_step_two_page.about_the_claimant do |section|
      node = section.send("#{hash['field']}".to_sym)
      case node.try(:tag_name)
        when "select" then node.select(hash['value'])
        else node.set(hash['value'])
      end
    end
  end

end

And(/^I fill in my refund claimant contact details with:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  table.hashes.each do | hash |
    refund_step_two_page.claimants_contact_details do |section|
      node = section.send("#{hash['field']}".to_sym)
      case node.try(:tag_name)
        when "select" then node.select(hash['value'])
        else node.set(hash['value'])
      end
    end
  end
end

And(/^I save the refund applicant details$/) do
  refund_step_two_page.save_and_continue.click
end


Then(/^the user should be informed that there are errors on the refund applicant page$/) do
  expect(refund_step_two_page.form_error_message).to be_visible
end


And(/^all mandatory fields in the refund applicant page should be marked with an error$/) do
  aggregate_failures do
    expect(refund_step_two_page.about_the_claimant.title.error.text).to eql "Select a title from the list"
    expect(refund_step_two_page.about_the_claimant.first_name.error.text).to eql "Enter the claimant's first name"
    expect(refund_step_two_page.about_the_claimant.last_name.error.text).to eql "Enter the claimant's last name"
    expect(refund_step_two_page.about_the_claimant.date_of_birth.error.text).to eql "Enter the claimant's date of birth"
    expect(refund_step_two_page.claimants_contact_details.building.error.text).to eql "Enter the building number or name from the claimant's address"
    expect(refund_step_two_page.claimants_contact_details.street.error.text).to eql "Enter the street from the claimant's address"
    expect(refund_step_two_page.claimants_contact_details.post_code.error.text).to eql "Enter the claimant's post code"
    expect(refund_step_two_page.claimants_contact_details.telephone_number.error.text).to eql "Enter the claimant's telephone number"
    expect(refund_step_two_page.claimants_contact_details.locality).to have_no_error, 'Expected locality not to have an error'
    expect(refund_step_two_page.claimants_contact_details.county).to have_no_error, 'Expected county not to have an error'
    expect(refund_step_two_page.claimants_contact_details.country).to have_no_error, 'Expected country not to have an error'
  end
end
