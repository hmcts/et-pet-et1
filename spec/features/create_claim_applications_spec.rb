require 'rails_helper'

feature 'Claim applications', type: :feature do
  include FormMethods
  include Messages

  before do
    stub_request(:post, 'https://etapi.employmenttribunals.service.gov.uk/1/fgr-office').
      with(postcode: 'AT1 4PQ').to_return body: fgr_response.to_json
  end

  let(:fgr_response) do
    {
      "fgr"               => 511234567800,
      "ETOfficeCode"      => 22,
      "ETOfficeName"      => "Birmingham",
      "ETOfficeAddress"   => "Centre City Tower, 5­7 Hill Street, Birmingham B5 4UU",
      "ETOfficeTelephone" => "0121 600 7780"
    }
  end

  scenario 'Create a new application' do
    start_claim
    expect(page).to have_text(claim_heading_for(:password))
  end

  scenario 'Entering word for save and return' do
    start_claim
    expect(page).to_not have_button('Complete later')
    fill_in_password 'green'

    claim = Claim.first
    expect(claim.authenticate 'green').to eq(claim)

    expect(page).to have_text(claim_heading_for(:claimant))
    expect(page).to have_button('Complete later')
  end

  scenario 'Entering word and email for save and return' do
    start_claim
    fill_in_password_and_email 'green', 'mail@example.com'

    claim = Claim.first
    expect(claim.authenticate 'green').to eq(claim)

    mail = ActionMailer::Base.deliveries.last
    expect(mail.subject).to include(claim.reference)

    expect(page).to have_text(claim_heading_for(:claimant))
  end

  scenario 'Entering personal details' do
    start_claim
    fill_in_password
    fill_in_personal_details

    expect(page).to have_text(claim_heading_for(:representative))
  end

  scenario 'Entering representative details' do
    start_claim
    fill_in_password
    fill_in_personal_details
    fill_in_representative_details

    expect(page).to have_text(claim_heading_for(:respondent))
  end

  scenario 'Entering employer details' do
    start_claim
    fill_in_password
    fill_in_personal_details
    fill_in_representative_details
    fill_in_employer_details

    expect(page).to have_text(claim_heading_for(:employment))
  end

  scenario 'Entering employment details' do
    start_claim
    fill_in_password
    fill_in_personal_details
    fill_in_representative_details
    fill_in_employer_details
    fill_in_employment_details

    expect(page).to have_text(claim_heading_for(:claim))
  end

  scenario 'Entering claim details' do
    start_claim
    fill_in_password
    fill_in_personal_details
    fill_in_representative_details
    fill_in_employer_details
    fill_in_employment_details
    fill_in_claim_details

    expect(page).to have_text(review_heading_for(:show))
  end
end
