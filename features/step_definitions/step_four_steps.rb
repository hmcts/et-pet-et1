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

And(/^I save the representative's details$/) do
  step_four_page.save_and_continue.click
end
