require 'rails_helper'

feature 'Save and Return' do
  include FormMethods
  include Messages
  include MailMatchers

  scenario 'ending the session actually ends the session' do
    start_claim
    fill_in_password
    fill_in_personal_details(submit_form: false)

    within 'aside' do
      click_button 'Save and complete later'
    end

    click_button 'Sign out now'

    visit claim_claimant_path

    expect(page.current_path).to_not eq claim_claimant_path
  end

  scenario 'ending the session with email address' do
    start_claim
    fill_in_password
    fill_in_personal_details(submit_form: false)

    within 'aside' do
      click_button 'Save and complete later'
    end

    expect(page).to have_text('Claim saved')
    expect(page).not_to have_signout_button
    expect(page).to have_text(Claim.last.reference)

    ActionMailer::Base.deliveries.clear
    fill_in 'Enter your email address to get your claim number emailed to you.',
      with: FormMethods::SAVE_AND_RETURN_EMAIL
    click_button 'Sign out now'

    mail = ActionMailer::Base.deliveries.last
    expect(mail).to match_pattern Claim.last.reference

    expect(page).to have_text(claim_heading_for(:new))
  end

  scenario 'ending the session when email address previously entered' do
    start_claim
    fill_in_password_and_email('green',
        FormMethods::SAVE_AND_RETURN_EMAIL,
        "application_number_email_address")

    fill_in_personal_details(submit_form: false)

    within 'aside' do
      click_button 'Save and complete later'
    end

    expect(page).to have_text(claim_heading_for(:new))
  end

  scenario 'ending the session when current page invalid' do
    start_claim
    fill_in_password

    within 'aside' do
      click_button 'Save and complete later'
    end

    expect(page).to have_text('Claim saved')
    expect(page).not_to have_signout_button
  end

  scenario 'returning to existing application' do
    start_claim
    fill_in_password 'green'
    fill_in_personal_details
    end_session
    fill_in_return_form Claim.last.reference, 'green'

    expect(page).to have_text(claim_heading_for(:claimant))
    expect(page).to have_field('Last name', with: 'Wrigglesworth')
  end

  scenario 'returning to an existing application after session expiration' do
    start_claim
    fill_in_password 'green'
    fill_in_personal_details

    travel_to TimeHelper.session_expiry_time do
      fill_in_return_form Claim.last.reference, 'green'
      expect(page).to have_text(claim_heading_for(:claimant))
      expect(page).to have_field('Last name', with: 'Wrigglesworth')
    end
  end

  context 'memorable word not set' do
    scenario 'returning to an existing application' do
      start_claim
      fill_in_return_form Claim.last.reference, 'memorable word was not set'

      expect(page).to have_text 'Return to your claim'
      expect(page).not_to have_signout_button
    end
  end
end
