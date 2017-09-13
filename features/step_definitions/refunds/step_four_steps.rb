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

