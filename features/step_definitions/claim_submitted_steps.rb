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
