require 'rails_helper'

RSpec.feature 'Viewing a claims details in the admin interface', type: :feature do

  include_context 'block pdf generation'

  let!(:claim_with_attachments) do
    create :claim, :submitted, :with_pdf,
      fee_group_reference: '511234567800',
      confirmation_email_recipients: %w<such@lolz.com wow@lol.biz>
  end

  around { |example| travel_to(Date.new(2015, 06, 05)) { example.run } }

  scenario 'viewing metadata about a particular claim' do
    visit admin_claim_path claim_with_attachments.reference

    expect(page).to have_text claim_with_attachments.reference

    { id: "Id #{claim_with_attachments.id}",
      submitted_to_jadu: 'Submitted To Jadu June 05, 2015 00:00',
      payment_required: 'Payment Required Yes',
      payment_received: 'Payment Received Yes',
      fee_group_reference: 'Fee Group Reference 511234567800',
      fgr_postcode: 'Fgr Postcode SW1A 1AH',
      confirmation_emails: 'Confirmation Emails such@lolz.com and wow@lol.biz'
    }.each do |css_class_suffix, expected_row_value|
      row_value = page.find(".row-#{css_class_suffix}").text
      expect(row_value).to eq expected_row_value
    end
  end

  scenario 'viewing event data related to a particular claim' do
    visit admin_claim_path claim_with_attachments.reference

    { event: 'created',
      actor: 'app',
      created_at: 'June 05, 2015 00:00',
      message: ''
    }.each do |css_class_suffix, expected_column_value|
      column_value = page.all("td.col-#{css_class_suffix}").first.text
      expect(column_value).to eq expected_column_value
    end
  end

  scenario 'generating the pdf' do
    visit admin_claim_path claim_with_attachments.reference

    allow(PdfGenerationJob).to receive(:perform_later)

    click_button 'Generate PDF'

    expect(current_path).to eq admin_claim_path claim_with_attachments.reference
    expect(page).to have_text 'Generating a new PDF'
  end

  scenario 'downloading the pdf' do
    allow_any_instance_of(Claim).to receive(:pdf_url).
      and_return('http://lol.biz/such.pdf')

    visit admin_claim_path claim_with_attachments.reference

    expect(page).to have_link('Download PDF', href: 'http://lol.biz/such.pdf')
  end

  scenario 'downloading the claim details rtf' do
    allow_any_instance_of(Claim).to receive(:claim_details_rtf_url).
      and_return('http://lol.biz/deets.rtf')

    visit admin_claim_path claim_with_attachments.reference

    expect(page).to have_link('Download RTF', href: 'http://lol.biz/deets.rtf')
  end

  scenario 'downloading the additional claimants csv' do
    allow_any_instance_of(Claim).to receive(:additional_claimants_csv_url).
      and_return('http://lol.biz/additionals.csv')

    visit admin_claim_path claim_with_attachments.reference

    expect(page).to have_link('Download CSV', href: 'http://lol.biz/additionals.csv')
  end

  context 'claim without attahcments' do
    let!(:claim_without_attachments) { create :claim, :no_attachments }

    before { visit admin_claim_path claim_without_attachments.reference }

    scenario 'no option to download the pdf' do
      expect(page).not_to have_link('Download PDF')
    end

    scenario 'no option to download the claim details rtf' do
      expect(page).not_to have_link('Download RTF')
    end

    scenario 'no option to download the additional claimants csv' do
      expect(page).not_to have_link('Download CSV')
    end
  end
end
