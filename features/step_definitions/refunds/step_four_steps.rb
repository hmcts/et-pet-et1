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


And(/^I ensure that my refund original case details claimant name is visible but disabled as:$/) do |table|
  table.hashes.each do | hash |
    refund_step_four_page.original_claimant_details do |section|
      node = section.send("#{hash['field']}".to_sym)
      raw_value = node.value
      value = case node.try(:tag_name)
                when "select" then within(node) { find("option[value=\"#{raw_value}\"]") }.text
                else raw_value
              end
      expect(value).to eql hash['value']
      expect(node).to be_disabled
    end
  end
end
