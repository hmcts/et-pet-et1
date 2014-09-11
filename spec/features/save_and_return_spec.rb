require 'rails_helper'

feature 'Save and Return' do
  include FormMethods
  include Messages

  scenario 'ending the session' do
    start_claim
    fill_in_password
    fill_in_personal_details(submit_form: false)

    click_button 'Complete later'
    expect(page).to have_text('Saved')
    expect(page).to have_text(Claim.last.reference)
    click_button 'Sign out now'

    expect(page).to have_text(claim_heading_for(:new))
  end

  scenario 'ending the session when current page invalid' do
    start_claim
    fill_in_password
    click_button 'Complete later'
    expect(page).to have_text('Saved')
  end

  scenario 'returning to existing application' do
    start_claim
    fill_in_password 'green'
    fill_in_personal_details(submit_form: false)
    end_session
    fill_in_return_form Claim.last.reference, 'green'

    expect(page).to have_text(claim_heading_for(:claimant))
    expect(page).to have_field('Last name', with: 'Wrigglesworth')
  end
end
