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


