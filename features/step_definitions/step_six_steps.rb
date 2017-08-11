And(/^I answer Yes to the additional respondents question$/) do
  step_six_page.more_than_one_employer.set("Yes")
end


And(/^I fill in the second respondent's details with:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  table.hashes.each do | hash |
    step_six_page.more_than_one_employer.respondent_two do |section|
      node = section.send("#{hash['field']}".to_sym)
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
  table.hashes.each do | hash |
    step_six_page.more_than_one_employer.respondent_three do |section|
      node = section.send("#{hash['field']}".to_sym)
      case node.try(:tag_name)
        when "select" then node.select(hash['value'])
        else node.set(hash['value'])
      end
    end
  end
end
