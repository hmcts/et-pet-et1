require 'rails_helper'

feature 'Claim applications', type: :feature do
  include FormMethods

  scenario 'Create a new application' do
    start_claim
    expect(page).to have_text('Your details')
  end

  scenario 'Choosing a password for save and return' do
    pending "Removed functionality for UT. Left as a pending as a reminder to reinstate, i.e. revert this particular commit"
    start_claim
    fill_in_password 'sup3r_s3cr3t'

    claim = Claim.first
    expect(claim.authenticate 'sup3r_s3cr3t').to eq(claim)

    expect(page).to have_text('Your details')
  end

  scenario 'Entering personal details' do
    start_claim
    fill_in_personal_details

    expect(page).to have_text("Your representative")
  end

  scenario 'Entering representative details' do
    start_claim
    fill_in_personal_details
    fill_in_representative_details

    expect(page).to have_text("Employer's details")
  end

  scenario 'Entering employer details' do
    start_claim
    fill_in_personal_details
    fill_in_representative_details
    fill_in_employer_details

    expect(page).to have_text("Employment details")
  end

  scenario 'Entering employment details' do
    start_claim
    fill_in_personal_details
    fill_in_representative_details
    fill_in_employer_details
    fill_in_employment_details

    expect(page).to have_text("Claim details")
  end

  scenario 'Entering claim details' do
    start_claim
    fill_in_personal_details
    fill_in_representative_details
    fill_in_employer_details
    fill_in_employment_details
    fill_in_claim_details

    expect(page).to have_text("Check your answers")
  end
end
