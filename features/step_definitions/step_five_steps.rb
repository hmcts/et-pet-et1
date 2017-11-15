And(/^I fill in the respondent's details with:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  table.hashes.each do |hash|
    step_five_page.about_the_respondent do |section|
      node = section.send((hash['field']).to_s.to_sym)
      case node.try(:tag_name)
      when "select" then node.select(hash['value'])
      else node.set(hash['value'])
      end
    end
  end
end

And(/^I fill in the respondent's details$/) do
  resp = test_user.et_case.respondent
  step_five_page.about_the_respondent do |s|
    s.name.set resp.name
    s.building.set resp.building
    s.street.set resp.street
    s.locality.set resp.locality
    s.county.set resp.county
    s.post_code.set resp.post_code
    s.telephone_number.set resp.telephone_number
  end
  step_five_page.your_work_address.same_address.set(test_user.et_case.worked_at_respondent_address)
  work_address = test_user.et_case.work_address
  step_five_page.your_work_address do |s|
    s.building.set work_address.building
    s.street.set work_address.street
    s.locality.set work_address.locality
    s.county.set work_address.county
    s.post_code.set work_address.post_code
    s.telephone_number.set work_address.telephone_number
  end

end

And(/^I answer No to working at the same address question$/) do
  step_five_page.your_work_address.same_address.set("No")
end

And(/^I fill in my work address with:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  table.hashes.each do |hash|
    step_five_page.your_work_address do |section|
      node = section.send((hash['field']).to_s.to_sym)
      case node.try(:tag_name)
      when "select" then node.select(hash['value'])
      else node.set(hash['value'])
      end
    end
  end
end

And(/^I fill in my acas certificate number with (.*)$/) do |cert_number|
  step_five_page.acas.certificate_number.set(cert_number)
end

And(/^I save the respondent's details$/) do
  step_five_page.save_and_continue.click
end
