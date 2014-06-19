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
  end

  scenario 'Entering personal details' do
    start_claim
    fill_in_password 'sup3r_s3cr3t'
    fill_in_personal_details

  end
end

def start_claim
  visit '/claims/new'
  click_button 'Start claim'
end

def fill_in_password(password)
  fill_in 'Password', with: password
  fill_in 'Password confirmation', with: password

  click_button 'Save and continue'
end

def fill_in_personal_details
  select 'Mr', from: 'Title'

  fill_in 'First name', with: 'Barrington'
  fill_in 'Last name',  with: 'Wrigglesworth'

  select 'Male', from: 'Gender'

  select '15',      from: :claim_claimants_attributes_0_date_of_birth_3i
  select 'January', from: :claim_claimants_attributes_0_date_of_birth_2i
  select '1985',    from: :claim_claimants_attributes_0_date_of_birth_1i

  fill_in 'Building number or name', with: '1'
  fill_in 'Street',                  with: 'High street'
  fill_in 'Town/city',               with: 'Anytown'
  fill_in 'County',                  with: 'Anyfordshire'
  fill_in 'Post code',               with: 'AT1 4PQ'
  fill_in 'Telephone',               with: '01234567890'
  fill_in 'Mobile',                  with: '07956000000'

  choose  'claim_claimants_contact_preference_email'
  fill_in 'Email address', with: 'barrington@example.com'

  choose  'claim_claimants_has_special_needs_yes'
  fill_in 'Tell us how we can help you.', with: 'I am blind.'

  choose  'claim_claimants_has_representative_yes'

  click_button 'Save and continue'
end
