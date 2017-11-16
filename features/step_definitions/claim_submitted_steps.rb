And(/^I save a copy of my claim$/) do
  claim_submitted_page.save_a_copy
end

Then(/^the claim pdf file should contain:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    table.hashes.each do |hash|
      expect(pdf_page.pdf_content).to have_field(hash['field'], with: hash['value'])
    end
  end
end

And(/^the claim pdf file's Your details section should contain:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    table.hashes.each do |hash|
      expect(pdf_page.pdf_document.your_details.send(hash['field'].to_sym).value).to eql hash['value']
    end
  end
end

And(/^the claim pdf file's Your details section should contain my details$/) do
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    pdf_page.pdf_document.your_details do |s|
      expect(s.title.value).to eql test_user.title
      expect(s.first_name.value).to eql test_user.first_name
      expect(s.last_name.value).to eql test_user.last_name
      expect(s.date_of_birth.value).to eql test_user.date_of_birth
      expect(s.gender.value).to eql test_user.gender
      expect(s.building.value).to eql test_user.address.building
      expect(s.street.value).to eql test_user.address.street
      expect(s.locality.value).to eql test_user.address.locality unless test_user.address.locality.nil?
      expect(s.county.value).to eql test_user.address.county unless test_user.address.county.nil?
      expect(s.post_code.value).to eql test_user.address.post_code
      expect(s.telephone_number.value).to eql test_user.telephone_number
      expect(s.alternative_telephone_number.value).to eql test_user.alternative_telephone_number unless test_user.alternative_telephone_number.nil?
      expect(s.email_address.value).to eql test_user.email_address unless test_user.email_address.nil?
      expect(s.correspondence.value).to eql test_user.correspondence unless test_user.correspondence.nil?
    end
  end
end

And(/^the claim pdf file's Respondent's details name section should contain:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    table.hashes.each do |hash|
      expect(pdf_page.pdf_document.respondents_details.name.send(hash['field'].to_sym).value).to eql hash['value']
    end
  end
end

And(/^the claim pdf file's Respondent's details address section should contain:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    table.hashes.each do |hash|
      expect(pdf_page.pdf_document.respondents_details.address.send(hash['field'].to_sym).value).to eql hash['value']
    end
  end
end

And(/^the claim pdf file's Respondent's details acas section should contain:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    table.hashes.each do |hash|
      expect(pdf_page.pdf_document.respondents_details.acas.send(hash['field'].to_sym).value).to eql hash['value']
    end
  end
end

And(/^the claim pdf file's Respondent's details different address section should contain:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    table.hashes.each do |hash|
      expect(pdf_page.pdf_document.respondents_details.different_address.send(hash['field'].to_sym).value).to eql hash['value']
    end
  end
end

And(/^the claim pdf file's Respondent's details second respondent name section should contain:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    table.hashes.each do |hash|
      expect(pdf_page.pdf_document.respondents_details.respondent_two.name.send(hash['field'].to_sym).value).to eql hash['value']
    end
  end
end

And(/^the claim pdf file's Respondent's details second respondent address section should contain:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    table.hashes.each do |hash|
      expect(pdf_page.pdf_document.respondents_details.respondent_two.address.send(hash['field'].to_sym).value).to eql hash['value']
    end
  end
end

And(/^the claim pdf file's Respondent's details second respondent acas section should contain:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    table.hashes.each do |hash|
      expect(pdf_page.pdf_document.respondents_details.respondent_two.acas.send(hash['field'].to_sym).value).to eql hash['value']
    end
  end
end

And(/^the claim pdf file's Respondent's details third respondent name section should contain:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    table.hashes.each do |hash|
      expect(pdf_page.pdf_document.respondents_details.respondent_three.name.send(hash['field'].to_sym).value).to eql hash['value']
    end
  end
end

And(/^the claim pdf file's Respondent's details third respondent address section should contain:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    table.hashes.each do |hash|
      expect(pdf_page.pdf_document.respondents_details.respondent_three.address.send(hash['field'].to_sym).value).to eql hash['value']
    end
  end
end

And(/^the claim pdf file's Respondent's details third respondent acas section should contain:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    table.hashes.each do |hash|
      expect(pdf_page.pdf_document.respondents_details.respondent_three.acas.send(hash['field'].to_sym).value).to eql hash['value']
    end
  end
end

And(/^the claim pdf file's Multiple cases section should contain:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    table.hashes.each do |hash|
      expect(pdf_page.pdf_document.multiple_cases.send(hash['field'].to_sym).value).to eql hash['value']
    end
  end
end

And(/^the claim pdf file's Respondent not your employer section should contain:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    table.hashes.each do |hash|
      expect(pdf_page.pdf_document.respondent_not_your_employer.send(hash['field'].to_sym).value).to eql hash['value']
    end
  end
end

And(/^the claim pdf file's Respondent Employment details section should contain:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    table.hashes.each do |hash|
      expect(pdf_page.pdf_document.employment_details.send(hash['field'].to_sym).value).to eql hash['value']
    end
  end
end

And(/^the claim pdf file's Respondent Earnings and benefits section should contain:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    table.hashes.each do |hash|
      expect(pdf_page.pdf_document.earnings_and_benefits.send(hash['field'].to_sym).value).to eql hash['value']
    end
  end
end

And(/^the claim pdf file's What happened since section should contain:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    table.hashes.each do |hash|
      expect(pdf_page.pdf_document.what_happened_since.send(hash['field'].to_sym).value).to eql hash['value']
    end
  end
end

And(/^the claim pdf file's Type and details of claim section should contain:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    table.hashes.each do |hash|
      expect(pdf_page.pdf_document.type_and_details_of_claim.send(hash['field'].to_sym).value).to eql hash['value']
    end
  end
end

And(/^the claim pdf file's What do you want section should contain:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    table.hashes.each do |hash|
      expect(pdf_page.pdf_document.what_do_you_want.send(hash['field'].to_sym).value).to eql hash['value']
    end
  end
end

And(/^the claim pdf file's Information to regulators section should contain:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    table.hashes.each do |hash|
      expect(pdf_page.pdf_document.information_to_regulators.send(hash['field'].to_sym).value).to eql hash['value']
    end
  end

end

And(/^the claim pdf file's Your representative section should contain:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    table.hashes.each do |hash|
      expect(pdf_page.pdf_document.your_representative.send(hash['field'].to_sym).value).to eql hash['value']
    end
  end
end

And(/^the claim pdf file's Disability section should contain:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    table.hashes.each do |hash|
      expect(pdf_page.pdf_document.disability.send(hash['field'].to_sym).value).to eql hash['value']
    end
  end
end

And(/^the claim pdf file's Additional respondents section should contain the following for respondent 4:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    table.hashes.each do |hash|
      expect(pdf_page.pdf_document.additional_respondents.respondent_four.send(hash['field'].to_sym).value).to eql hash['value']
    end
  end
end

And(/^the claim pdf file's Additional respondents section should contain the following for respondent 5:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    table.hashes.each do |hash|
      expect(pdf_page.pdf_document.additional_respondents.respondent_five.send(hash['field'].to_sym).value).to eql hash['value']
    end
  end
end

And(/^the claim pdf file's Final check section should contain:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    table.hashes.each do |hash|
      expect(pdf_page.pdf_document.final_check.send(hash['field'].to_sym).value).to eql hash['value']
    end
  end
end

And(/^the claim pdf file's Additional information section should contain:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    table.hashes.each do |hash|
      expect(pdf_page.pdf_document.additional_information.send(hash['field'].to_sym).value).to eql hash['value']
    end
  end
end


And(/^the employment tribunal claim pdf file's Respondent's details should match the first 3 of mine$/) do
  claim_submitted_page.within_popup_window do
    pdf_page = ClaimSubmittedPdfPage.new
    expect(pdf_page).to be_displayed
    doc = pdf_page.pdf_document
    (1..3).each do |idx|
      root = doc.respondents_details if idx == 1
      root = doc.respondents_details.send("respondent_#{idx}") unless idx == 1
      respondent = test_user.et_case.respondent if idx == 1
      respondent = test_user.et_case.additional_respondents[idx - 2] if idx > 1

      expect(root.name.name.value).to eql respondent.name

      address = root.address
      if idx == 1
        # Only the first respondent is expected to have a telelphone number
        # unsure if this is correct, but its how it is for now.
        expect(address.telephone_number.value).to eql respondent.telephone_number

        # Only the first has a potential different address captured
        if(test_user.et_case.worked_at_respondent_address == 'No')
          work_address = test_user.et_case.work_address
          root.different_address do |s|
            expect(s.building.value).to eql work_address.building
            expect(s.street.value).to eql work_address.street
            expect(s.locality.value).to eql work_address.locality
            expect(s.county.value).to eql work_address.county
            expect(s.post_code.value).to eql work_address.post_code.gsub(/ /, '')
            expect(s.telephone_number.value).to eql work_address.telephone_number
          end
        end
      end
      expect(address.building.value).to eql respondent.building
      expect(address.street.value).to eql respondent.street
      expect(address.locality.value).to eql respondent.locality
      expect(address.county.value).to eql respondent.county
      expect(address.post_code.value).to eql respondent.post_code.gsub(/ /, '')

      acas = root.acas
      expect(acas.have_acas.value).to eql respondent.acas_number.present? ? 'Yes' : 'No'
      expect(acas.acas_number.value).to eql respondent.acas_number
    end




  end

end
