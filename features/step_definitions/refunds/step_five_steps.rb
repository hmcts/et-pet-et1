And(/^I fill in my refund bank details with:$/) do |table|
  table.hashes.each do | hash |
    refund_step_five_page.bank_details do |section|
      node = section.send("#{hash['field']}".to_sym)
      case node.try(:tag_name)
        when "select" then node.select(hash['value'])
        else node.set(hash['value'])
      end
    end
  end
end



And(/^I save the refund bank details$/) do
  refund_step_five_page.save_and_continue.click
end
