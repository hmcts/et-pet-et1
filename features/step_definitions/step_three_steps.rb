And(/^I answer Yes to the group claims question$/) do
  step_three_page.group_claims.set("Yes")
end

And(/^I fill in the first group claimant details with:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  table.hashes.each do |hash|
    step_three_page.group_claims.about_claimant_two do |section|
      node = section.send((hash['field']).to_s.to_sym)
      case node.try(:tag_name)
      when "select" then node.select(hash['value'])
      else node.set(hash['value'])
      end
    end
  end
end

And(/^I fill in my group claimant details$/) do
  test_user.et_case.group_claimants.each_with_index do |c, idx|
    if idx == 0
      step 'I answer Yes to the group claims question'
    else
      step 'I choose to add more claimants'
    end
    section_method = "about_claimant_#{idx + 2}".to_sym
    step_three_page.group_claims.send(section_method) do |s|
      s.title.set c.title
      s.first_name.set c.first_name
      s.last_name.set c.last_name
      s.date_of_birth.set c.date_of_birth
      s.building.set c.building
      s.street.set c.street
      s.locality.set c.locality
      s.county.set c.county
      s.post_code.set c.post_code
    end
  end
end

And(/^I fill in the second group claimant details with:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  table.hashes.each do |hash|
    step_three_page.group_claims.about_claimant_three do |section|
      node = section.send((hash['field']).to_s.to_sym)
      case node.try(:tag_name)
      when "select" then node.select(hash['value'])
      else node.set(hash['value'])
      end
    end
  end
end

And(/^I save the group claims$/) do
  step_three_page.save_and_continue.click
end

And(/^I choose to add more claimants$/) do
  step_three_page.group_claims.add_more_claimants.click
end

And(/^I fill in the third group claimant details with:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  table.hashes.each do |hash|
    step_three_page.group_claims.about_claimant_four do |section|
      node = section.send((hash['field']).to_s.to_sym)
      case node.try(:tag_name)
      when "select" then node.select(hash['value'])
      else node.set(hash['value'])
      end
    end
  end
end

And(/^I fill in the fourth group claimant details with:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  table.hashes.each do |hash|
    step_three_page.group_claims.about_claimant_five do |section|
      node = section.send((hash['field']).to_s.to_sym)
      case node.try(:tag_name)
      when "select" then node.select(hash['value'])
      else node.set(hash['value'])
      end
    end
  end
end

And(/^I fill in the fifth group claimant details with:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  table.hashes.each do |hash|
    step_three_page.group_claims.about_claimant_six do |section|
      node = section.send((hash['field']).to_s.to_sym)
      case node.try(:tag_name)
      when "select" then node.select(hash['value'])
      else node.set(hash['value'])
      end
    end
  end
end
