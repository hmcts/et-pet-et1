And(/^I answer Yes to the are you the claimant question for refunds$/) do
  refund_step_two_page.is_claimant.set("Yes")
end


And(/^I answer (Yes|No) to the has your name changed question for refunds$/) do |value|
  refund_step_two_page.has_name_changed.set(value)
end

And(/^I fill in my refund claimant details with:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  table.hashes.each do | hash |
    refund_step_two_page.about_the_claimant do |section|
      node = section.send("#{hash['field']}".to_sym)
      case node.try(:tag_name)
        when "select" then node.select(hash['value'])
        else node.set(hash['value'])
      end
    end
  end

end

And(/^I fill in my refund claimant contact details with:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  table.hashes.each do | hash |
    refund_step_two_page.claimants_contact_details do |section|
      node = section.send("#{hash['field']}".to_sym)
      case node.try(:tag_name)
        when "select" then node.select(hash['value'])
        else node.set(hash['value'])
      end
    end
  end
end

And(/^I answer No to the has your address changed question for refunds$/) do
  refund_step_two_page.has_address_changed.set("No")
end

And(/^I save the refund applicant details$/) do
  refund_step_two_page.save_and_continue.click
end
