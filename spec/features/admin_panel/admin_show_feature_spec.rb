require 'rails_helper'

RSpec.feature 'Viewing a claims details in the admin interface', type: :feature do
  let!(:claim_with_attachments) do
    create :claim, :submitted, :with_pdf,
      fee_group_reference: '511234567800',
      confirmation_email_recipients: ['such@lolz.com', 'wow@lol.biz']
  end

  let!(:enqueued_claim) do
    create :claim, :with_pdf,
      fee_group_reference: '511234567800',
      confirmation_email_recipients: ['such@lolz.com', 'wow@lol.biz']
  end

  context 'with time frozen' do
    around { |example| travel_to(Date.new(2015, 6, 5)) { example.run } }

    scenario 'viewing metadata about a particular claim' do
      visit admin_claim_path claim_with_attachments.reference

      expect(page).to have_text claim_with_attachments.reference

      {
        id: "Id #{claim_with_attachments.id}",
        submitted_to_jadu: 'Submitted To Jadu June 05, 2015 00:00',
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

      {
        event: 'created',
        actor: 'app',
        created_at: 'June 05, 2015 00:00',
        message: ''
      }.each do |css_class_suffix, expected_column_value|
        column_value = page.all("td.col-#{css_class_suffix}").first.text
        expect(column_value).to eq expected_column_value
      end
    end
  end

  scenario 'downloading the claim details rtf' do
    allow(Claim).to receive(:find_by_reference).and_return claim_with_attachments
    allow(claim_with_attachments).to receive(:claim_details_rtf_url).
      and_return('http://lol.biz/deets.rtf')

    visit admin_claim_path claim_with_attachments.reference

    expect(page).to have_link 'Download RTF', href: 'http://lol.biz/deets.rtf'
  end

  scenario 'downloading a text file containing claim details' do
    visit admin_claim_path claim_with_attachments.reference

    click_link 'Claim details'

    expect(page.response_headers['Content-Type']).to eq 'text/plain'
    expect(page.body).to eq 'I am sad'
  end

  scenario 'downloading a text file containing miscellaneous information' do
    visit admin_claim_path claim_with_attachments.reference

    click_link 'Miscellaneous information'

    expect(page.response_headers['Content-Type']).to eq 'text/plain'
    expect(page.body).to eq 'Still really sad'
  end

  scenario 'downloading a text file containing other claim details' do
    visit admin_claim_path claim_with_attachments.reference

    click_link 'Other claim details'

    expect(page.response_headers['Content-Type']).to eq 'text/plain'
    expect(page.body).to eq 'Really sad'
  end

  scenario 'downloading a text file containing other outcome' do
    visit admin_claim_path claim_with_attachments.reference

    click_link 'Other outcome'

    expect(page.response_headers['Content-Type']).to eq 'text/plain'
    expect(page.body).to eq 'I wanna take him to the cleaners!'
  end

  scenario 'marking claim as submitted' do

    visit admin_claim_path enqueued_claim.reference

    click_button 'Mark as submitted'
    expect(enqueued_claim.reload.state).to eq 'submitted'

    event = enqueued_claim.events.reload.first

    expect(event.claim_state).to eq 'submitted'
    expect(event.event).to eq Event::MANUAL_STATUS_CHANGE
    expect(event.actor).to eq 'admin'
  end

  scenario 're-submitting a claim', clean_with_truncation: true do

    fake_response = instance_spy('SubmitClaimToApiService', valid?: true, errors: [], response_data: { 'meta' => { 'BuildClaim' => { 'pdf_url' => 'http://anything.com/test.pdf' }}})
    expect(EtApi).to receive(:create_claim).with(enqueued_claim).and_return(fake_response)

    visit admin_claim_path enqueued_claim.reference

    click_button 'Submit claim'
    expect(page).to have_text 'Claim submitted to API'
    event = Claim.find(enqueued_claim.id).events.first
    expect(event.event).to eq Event::MANUALLY_SUBMITTED
    expect(event.actor).to eq 'admin'
  end

  context 'claim without large text inputs' do
    let!(:claim_without_large_text_inputs) do
      create :claim,
        claim_details: nil,
        miscellaneous_information: nil,
        other_claim_details: nil,
        other_outcome: nil
    end

    before { visit admin_claim_path claim_without_large_text_inputs.reference }

    scenario 'no option to download claim details as a text file' do
      expect(page).not_to have_link 'Claim details'
    end

    scenario 'no option to download miscellaneous information as a text file' do
      expect(page).not_to have_link 'Miscellaneous information'
    end

    scenario 'no option to download other claim details as a text file' do
      expect(page).not_to have_link 'Other claim details'
    end

    scenario 'no option to download other outcome as a text file' do
      expect(page).not_to have_link 'Other outcome'
    end
  end

  context 'claim without attachments' do
    let!(:claim_without_attachments) { create :claim, :no_attachments }

    before { visit admin_claim_path claim_without_attachments.reference }

    scenario 'no option to download the claim details rtf' do
      expect(page).not_to have_link 'Download RTF'
    end

    scenario 'no option to download the additional claimants csv' do
      expect(page).not_to have_link 'Download CSV'
    end
  end
end
