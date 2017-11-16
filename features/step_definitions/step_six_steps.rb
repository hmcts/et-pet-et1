And(/^I answer Yes to the additional respondents question$/) do
  step_six_page.more_than_one_employer.set("Yes")
end

And(/^I fill in the second respondent's details with:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  table.hashes.each do |hash|
    step_six_page.more_than_one_employer.respondent_two do |section|
      node = section.send((hash['field']).to_s.to_sym)
      case node.try(:tag_name)
      when "select" then node.select(hash['value'])
      else node.set(hash['value'])
      end
    end
  end
end

And(/^I save the additional respondents$/) do
  step_six_page.save_and_continue.click
end

And(/^I choose to add another respondent$/) do
  step_six_page.more_than_one_employer.add_another_respondent.click
end

And(/^I fill in the third respondent's details with:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  table.hashes.each do |hash|
    step_six_page.more_than_one_employer.respondent_three do |section|
      node = section.send((hash['field']).to_s.to_sym)
      case node.try(:tag_name)
      when "select" then node.select(hash['value'])
      else node.set(hash['value'])
      end
    end
  end
end

And(/^I fill in the fourth respondent's details with:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  table.hashes.each do |hash|
    step_six_page.more_than_one_employer.respondent_four do |section|
      node = section.send((hash['field']).to_s.to_sym)
      case node.try(:tag_name)
      when "select" then node.select(hash['value'])
      else node.set(hash['value'])
      end
    end
  end
end

And(/^I fill in the fifth respondent's details with:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  table.hashes.each do |hash|
    step_six_page.more_than_one_employer.respondent_five do |section|
      node = section.send((hash['field']).to_s.to_sym)
      case node.try(:tag_name)
      when "select" then node.select(hash['value'])
      else node.set(hash['value'])
      end
    end
  end
end


And(/^I fill in my additional respondents for an employee tribunal$/) do
  if test_user.et_case.additional_respondents.present?
    test_user.et_case.additional_respondents.each_with_index do |resp, idx|
      if idx == 0
        step 'I answer Yes to the additional respondents question'
      else
        step 'I choose to add another respondent'
      end
      section_method = "respondent_#{idx + 2}".to_sym
      step_six_page.more_than_one_employer.send(section_method) do |s|
        s.name.set resp.name
        s.building.set resp.building
        s.street.set resp.street
        s.locality.set resp.locality
        s.county.set resp.county
        s.post_code.set resp.post_code
        s.acas_number.set resp.acas_number
      end

    end
  else
    step 'I answer No to the additional respondents question'
  end
end
