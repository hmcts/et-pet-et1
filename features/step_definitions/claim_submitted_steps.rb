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
