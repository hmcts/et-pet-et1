And(/^I answer Yes to the representative question$/) do
  step_four_page.representatives_details do |r|
    r.representative.set("Yes")
  end
end

And(/^I fill in the representative's details with:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  table.hashes.each do |hash|
    step_four_page.representatives_details.about_your_representative do |section|
      node = section.send((hash['field']).to_s.to_sym)
      case node.try(:tag_name)
      when "select" then node.select(hash['value'])
      else node.set(hash['value'])
      end
    end
  end
end

And(/^I fill in the representative's contact details with:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  table.hashes.each do |hash|
    step_four_page.representatives_details.contact_details do |section|
      node = section.send((hash['field']).to_s.to_sym)
      case node.try(:tag_name)
      when "select" then node.select(hash['value'])
      else node.set(hash['value'])
      end
    end
  end
end

And(/^I fill in the representative's details$/) do
  step 'I answer Yes to the representative question'
  rep = test_user.et_case.representative
  step_four_page.representatives_details.about_your_representative do |s|
    s.type.set rep.type
    s.organisation_name.set rep.organisation_name
    s.name.set rep.name
  end
  step_four_page.representatives_details.contact_details do |s|
    s.building.set rep.address.building
    s.street.set rep.address.street
    s.locality.set rep.address.locality
    s.county.set rep.address.county
    s.post_code.set rep.address.post_code
    s.telephone_number.set rep.telephone_number
    s.alternative_telephone_number.set rep.alternative_telephone_number
    s.email_address.set rep.email_address
    s.dx_number.set rep.dx_number
  end
end

And(/^I save the representative's details$/) do
  step_four_page.save_and_continue.click
end
