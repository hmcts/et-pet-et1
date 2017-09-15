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


And(/^I fill in my refund bank details$/) do
  refund_step_five_page.bank_details do |section|
    section.account_name.set(test_user.bank_account.account_name)
    section.bank_name.set(test_user.bank_account.bank_name)
    section.account_number.set(test_user.bank_account.account_number)
    section.sort_code.set(test_user.bank_account.sort_code)
  end
  step('I take a screenshot named "Page 4 - Bank Account Details"')
  refund_step_five_page.save_and_continue.click

end


Then(/^I should see the refund bank details page$/) do
  expect(refund_step_five_page).to be_displayed
end
