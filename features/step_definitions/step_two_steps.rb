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

And(/^I fill in my claimant contact details$/) do
  step_two_page.claimants_contact_details do |s|
    s.building.set(test_user.address.building)
    s.street.set(test_user.address.street)
    s.locality.set(test_user.address.locality) unless test_user.address.locality.nil?
    s.county.set(test_user.address.county) unless test_user.address.county.nil?
    s.post_code.set(test_user.address.post_code)
    s.country.set(test_user.address.country) unless test_user.address.country.nil?
    s.telephone_number.set(test_user.telephone_number) unless test_user.telephone_number.nil?
    s.alternative_telephone_number.set(test_user.alternative_telephone_number) unless test_user.alternative_telephone_number.nil?
    s.email_address.set(test_user.email_address) unless test_user.email_address.nil?
    s.correspondence.set(test_user.correspondence) unless test_user.correspondence.nil?
  end
end

And(/^I save the claimant details$/) do
  step_two_page.save_and_continue.click
end


And(/^I fill in my claimant details$/) do
  step_two_page.about_the_claimant do |section|
    section.title.set(test_user.title)
    section.first_name.set(test_user.first_name)
    section.last_name.set(test_user.last_name)
    section.date_of_birth.set(test_user.date_of_birth)
    section.gender.set(test_user.gender)
    section.has_special_needs.set(test_user.et_case.special_needs.present? ? 'Yes' : 'No')
    section.special_needs.set(test_user.et_case.special_needs) if test_user.et_case.special_needs.present?
  end
end
