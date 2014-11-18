require 'rails_helper'

feature 'Save and Return' do
  include FormMethods
  include Messages

  scenario 'ending the session with email address' do
    start_claim
    fill_in_password
    fill_in_personal_details(submit_form: false)

    click_link 'Save and complete later'
    expect(page).to have_text('Application saved')
    expect(page).to have_text(Claim.last.reference)

    ActionMailer::Base.deliveries.clear
    fill_in 'Email address',
      with: FormMethods::SAVE_AND_RETURN_EMAIL
    click_button 'Sign out now'

    mail = ActionMailer::Base.deliveries.last
    expect(mail.subject).to include(Claim.last.reference)

    expect(page).to have_text(claim_heading_for(:new))
  end

  scenario 'ending the session when email address previously entered' do
    start_claim
    fill_in_password_and_email('green',
        FormMethods::SAVE_AND_RETURN_EMAIL,
        "application_number_email_address")

    fill_in_personal_details(submit_form: false)

    click_link 'Save and complete later'

    expect(page).to have_text(claim_heading_for(:new))
  end

  scenario 'ending the session when current page invalid' do
    start_claim
    fill_in_password
    click_link 'Save and complete later'
    expect(page).to have_text('Application saved')
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
end
