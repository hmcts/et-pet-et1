require 'rails_helper'

feature 'Claim applications', type: :feature do
  scenario 'Create a new application' do
    start_claim
    expect(page).to have_text(Claim.first.reference)
  end

  scenario 'Choosing a password for save and return' do
    start_claim
    fill_in_password 'sup3r_s3cr3t'

    claim = Claim.first
    expect(claim.authenticate 'sup3r_s3cr3t').to eq(claim)

    expect(page).to have_text('Your details')
  end

  scenario 'Entering personal details' do
    start_claim
    fill_in_password 'sup3r_s3cr3t'
    fill_in_personal_details

    expect(page).to have_text("Your representative")
  end

  scenario 'Entering representative details' do
    start_claim
    fill_in_password 'sup3r_s3cr3t'
    fill_in_personal_details
    fill_in_representative_details

    expect(page).to have_text("Employer's details")
  end

  scenario 'Entering employer details' do
    start_claim
    fill_in_password 'sup3r_s3cr3t'
    fill_in_personal_details
    fill_in_representative_details
    fill_in_employer_details

    expect(page).to have_text("Employment details")
  end

  scenario 'Entering employment details' do
    start_claim
    fill_in_password 'sup3r_s3cr3t'
    fill_in_personal_details
    fill_in_representative_details
    fill_in_employer_details
    fill_in_employment_details

    expect(page).to have_text("Claim details")
  end
end

def start_claim
  visit '/'
  click_button 'Start claim'
end

def fill_in_password(password)
  fill_in 'Create a password', with: password
  fill_in 'Confirm your password', with: password

  click_button 'Save and continue'
end

def fill_in_personal_details
  select 'Mr', from: 'Title'

  fill_in 'First name', with: 'Barrington'
  fill_in 'Last name',  with: 'Wrigglesworth'

  select 'Male', from: 'Gender'

  fill_in :claimant_date_of_birth_3i, with: '15'
  fill_in :claimant_date_of_birth_2i, with: '01'
  fill_in :claimant_date_of_birth_1i, with: '1985'

  fill_in_address

  fill_in 'Mobile (if different)',   with: '07956000000'

  choose  'claimant_contact_preference_email'
  fill_in 'Email address', with: 'barrington@example.com'

  choose  'claimant_has_special_needs_true'
  fill_in 'Tell us how we can help you.', with: 'I am blind.'

  choose  'claimant_has_representative_true'

  click_button 'Save and continue'
end

def fill_in_representative_details
  select 'Solicitor', from: 'Type of representative'
  fill_in "Name of the representative's organisation", with: 'Better Call Saul'
  fill_in "Representative's name", with: 'Saul Goodman'

  fill_in_address

  fill_in 'Mobile (if different)',   with: '07956000000'


  fill_in 'Document exchange (DX) number', with: '1'

  click_button 'Save and continue'
end

def fill_in_address
  fill_in 'Building number or name', with: '1'
  fill_in 'Street',                  with: 'High street'
  fill_in 'Town/city',               with: 'Anytown'
  fill_in 'County',                  with: 'Anyfordshire'
  fill_in 'Post code',               with: 'AT1 4PQ'
  fill_in 'Telephone',               with: '01234567890'
end

def fill_in_employer_details
  fill_in 'Name', with: 'Crappy Co, LTD'

  fill_in :respondent_address_building,         with: '2'
  fill_in :respondent_address_street,           with: 'Main street'
  fill_in :respondent_address_locality,         with: 'Anytown'
  fill_in :respondent_address_county,           with: 'Anyfordshire'
  fill_in :respondent_address_post_code,        with: 'AT3 0AS'
  fill_in :respondent_address_telephone_number, with: '01234567890'

  choose 'respondent_worked_at_different_address_true'

  fill_in_address

  check 'No acas number'
  choose 'respondent_no_acas_number_reason_acas_has_no_jurisdiction'

  choose 'respondent_was_employed_true'

  click_button 'Save and continue'
end

def fill_in_employment_details
  fill_in 'Job or job title', with: 'Super High Powered Exec'

  fill_in :employment_start_date_3i, with: '01'
  fill_in :employment_start_date_2i, with: '07'
  fill_in :employment_start_date_1i, with: '2000'

  fill_in 'Average hours worked each week', with: 37.5
  fill_in 'Pay before tax', with: 10000
  choose  'employment_gross_pay_period_type_weekly'
  fill_in 'Pay after tax',  with: 6000
  choose  'employment_net_pay_period_type_weekly'

  click_button 'Save and continue'
end
