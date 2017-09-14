And(/^I fill in my claimant details with:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  table.hashes.each do |hash|
    step_two_page.about_the_claimant do |section|
      node = section.send((hash['field']).to_s.to_sym)
      case node.try(:tag_name)
      when "select" then node.select(hash['value'])
      else node.set(hash['value'])
      end
    end
  end

end

And(/^I fill in my claimant contact details with:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  table.hashes.each do |hash|
    step_two_page.claimants_contact_details do |section|
      node = section.send((hash['field']).to_s.to_sym)
      case node.try(:tag_name)
      when "select" then node.select(hash['value'])
      else node.set(hash['value'])
      end
    end
  end
end

And(/^I save the claimant details$/) do
  step_two_page.save_and_continue.click
end


And(/^I fill in my refund applicant details$/) do
  refund_step_two_page.has_name_changed.set(test_user.has_name_changed) unless test_user.has_name_changed.nil?
  refund_step_two_page.about_the_claimant do |section|
    section.title.set(test_user.title)
    section.first_name.set(test_user.first_name)
    section.last_name.set(test_user.last_name)
    section.date_of_birth.set(test_user.date_of_birth)
  end
  refund_step_two_page.claimants_contact_details do |section|
    section.building.set(test_user.address.building)
    section.street.set(test_user.address.street)
    section.locality.set(test_user.address.locality)
    section.county.set(test_user.address.county)
    section.country.select(test_user.address.country)
    section.post_code.set(test_user.address.post_code)
    section.telephone_number.set(test_user.telephone_number)
    section.email_address.set(test_user.email_address)
  end
  step("I take a screenshot named \"Page 2 - Applicant Details\"")
  step("I save the refund applicant details")

end
