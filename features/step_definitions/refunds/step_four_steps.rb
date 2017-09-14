And(/^I fill in my refund original case details with:$/) do |table|
  table.hashes.each do | hash |
    refund_step_four_page.original_case_details do |section|
      node = section.send("#{hash['field']}".to_sym)
      case node.try(:tag_name)
        when "select" then node.select(hash['value'])
        else node.set(hash['value'])
      end
    end
  end
end


And(/^I fill in my refund original case details respondent details with:$/) do |table|
  table.hashes.each do | hash |
    refund_step_four_page.original_respondent_details do |section|
      node = section.send("#{hash['field']}".to_sym)
      case node.try(:tag_name)
        when "select" then node.select(hash['value'])
        else node.set(hash['value'])
      end
    end
  end
end

And(/^I fill in my refund original case details representative details with:$/) do |table|
  table.hashes.each do | hash |
    refund_step_four_page.original_representative_details do |section|
      node = section.send("#{hash['field']}".to_sym)
      case node.try(:tag_name)
        when "select" then node.select(hash['value'])
        else node.set(hash['value'])
      end
    end
  end
end


And(/^I fill in my refund issue fee with:$/) do |table|
  table.hashes.each do | hash |
    refund_step_four_page.original_claim_fees.et_issue do |section|
      section.fee.set(hash['fee'])
      section.payment_method.select(hash['payment method'])
    end
  end
end

And(/^I fill in my refund hearing fee with:$/) do |table|
  table.hashes.each do | hash |
    refund_step_four_page.original_claim_fees.et_hearing do |section|
      section.fee.set(hash['fee'])
      section.payment_method.select(hash['payment method'])
    end
  end
end

And(/^I fill in my refund eat issue fee with:$/) do |table|
  table.hashes.each do | hash |
    refund_step_four_page.original_claim_fees.eat_issue do |section|
      section.fee.set(hash['fee'])
      section.payment_method.select(hash['payment method'])
    end
  end
end

And(/^I fill in my refund eat hearing fee with:$/) do |table|
  table.hashes.each do | hash |
    refund_step_four_page.original_claim_fees.eat_hearing do |section|
      section.fee.set(hash['fee'])
      section.payment_method.select(hash['payment method'])
    end
  end
end

And(/^I fill in my refund application reconsideration fee with:$/) do |table|
  table.hashes.each do | hash |
    refund_step_four_page.original_claim_fees.app_reconsideration do |section|
      section.fee.set(hash['fee'])
      section.payment_method.select(hash['payment method'])
    end
  end
end

And(/^I answer Yes to the address same as applicant question for refunds$/) do
  refund_step_four_page.address_same_as_applicant.set("Yes")
end


And(/^I save the refund case details$/) do
  refund_step_four_page.save_and_continue.click
end


And(/^I fill in my refund original case details$/) do
  refund_step_four_page.address_same_as_applicant.set(test_user.claim_address_same) unless test_user.claim_address_same.nil?
  refund_step_four_page.original_case_details do |section|
    section.et_case_number.set(test_user.et_claim_to_refund.et_case_number)
    section.et_tribunal_office.set(test_user.et_claim_to_refund.et_tribunal_office)
    section.additional_information.set(test_user.et_claim_to_refund.additional_information)
  end
  refund_step_four_page.original_respondent_details do |section|
    section.name.set(test_user.et_claim_to_refund.respondent.name)
    section.post_code.set(test_user.et_claim_to_refund.respondent.post_code)
  end
  refund_step_four_page.original_representative_details do |section|
    section.name.set(test_user.et_claim_to_refund.representative.name)
    section.post_code.set(test_user.et_claim_to_refund.representative.post_code)
  end
  refund_step_four_page.original_claim_fees.et_issue do |section|
    section.fee.set(test_user.et_claim_to_refund.fees.et_issue_fee)
    section.payment_method.select(test_user.et_claim_to_refund.fees.et_issue_payment_method)
  end
  refund_step_four_page.original_claim_fees.et_hearing do |section|
    section.fee.set(test_user.et_claim_to_refund.fees.et_hearing_fee)
    section.payment_method.select(test_user.et_claim_to_refund.fees.et_hearing_payment_method)
  end
  refund_step_four_page.original_claim_fees.eat_issue do |section|
    section.fee.set(test_user.et_claim_to_refund.fees.eat_issue_fee)
    section.payment_method.select(test_user.et_claim_to_refund.fees.eat_issue_payment_method)
  end
  refund_step_four_page.original_claim_fees.eat_hearing do |section|
    section.fee.set(test_user.et_claim_to_refund.fees.eat_hearing_fee)
    section.payment_method.select(test_user.et_claim_to_refund.fees.eat_hearing_payment_method)
  end
  refund_step_four_page.original_claim_fees.app_reconsideration do |section|
    section.fee.set(test_user.et_claim_to_refund.fees.app_reconsideration_fee)
    section.payment_method.select(test_user.et_claim_to_refund.fees.app_reconsideration_payment_method)
  end
  step('I take a screenshot named "Page 3 - Original Case Details"')
  refund_step_four_page.save_and_continue.click

end
