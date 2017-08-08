And(/^I answer Yes to the group claims question$/) do
  step_three_page.group_claims.set("Yes")
end


And(/^I fill in the first group claimant details with:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  table.hashes.each do | hash |
    step_three_page.group_claims.about_claimant_two do |section|
      node = section.send("#{hash['field']}".to_sym)
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
