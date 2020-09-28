require 'rails_helper'

feature 'Save and Return' do
  include FormMethods
  include Messages
  include MailMatchers
  include ActiveJob::TestHelper
  include ActiveJobPerformHelper

  scenario 'ending the session actually ends the session' do
    start_claim
    fill_in_password
    fill_in_personal_details(submit_form: false)

    within 'aside' do
      click_button 'Save and complete later'
    end

    click_button 'Sign out now'

    visit claim_claimant_path

    expect(page.current_path).not_to eq claim_claimant_path
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

    perform_active_jobs(ActionMailer::DeliveryJob)
    mail = ActionMailer::Base.deliveries.last
    expect(mail).to match_pattern Claim.last.reference

    expect(page).to have_text(claim_heading_for(:new))
  end

  scenario 'ending the session when email address previously entered', js: true do
    start_claim
    fill_in_password_and_email('green',
      FormMethods::SAVE_AND_RETURN_EMAIL,
      "save_and_return_user_email")

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

  scenario 'returning to existing application', js: true do
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

  context 'forgotten memorable word', js:true do
    let(:email_address) { 'doesntmatter@example.com' }
    it 'recovers correctly when the email is not used at the beginning but when saved' do

      apply_page.load.start_a_claim
        .register(email_address: nil, password: 'green')
      claimants_details_page
        .fill_in_all(claimant: build(:ui_claimant, :mandatory))
        .save_and_complete_later
        .with(email_address: email_address)
      apply_page.return_to_a_claim
        .reset_memorable_word
        .using(email_address: email_address, claim_number: Claim.last.application_reference)
        .assert_memorable_word_email_sent

      perform_active_jobs(ActionMailer::DeliveryJob)

      reset_memorable_word_page.from_email_for(email_address)
        .set_memorable_word('newmemorableword')
        .return_to_your_claim(claim_number: Claim.last.application_reference, memorable_word: 'newmemorableword')
      expect(claimants_details_page).to be_displayed
    end

    it 'recovers correctly when the email used at the beginning' do

      apply_page.load.start_a_claim
        .register(email_address: email_address, password: 'green')
      claimants_details_page
        .fill_in_all(claimant: build(:ui_claimant, :mandatory))
        .save_and_complete_later
      apply_page.return_to_a_claim
        .reset_memorable_word
        .using(email_address: email_address, claim_number: Claim.last.application_reference)
        .assert_memorable_word_email_sent

      perform_active_jobs(ActionMailer::DeliveryJob)

      reset_memorable_word_page.from_email_for(email_address)
        .set_memorable_word('newmemorableword')
        .return_to_your_claim(claim_number: Claim.last.application_reference, memorable_word: 'newmemorableword')
      expect(claimants_details_page).to be_displayed
    end

    it 'allows a second claim to be used against the same email' do
      apply_page.load.start_a_claim
        .register(email_address: email_address, password: 'green')
      claimants_details_page
        .fill_in_all(claimant: build(:ui_claimant, :mandatory, first_name: 'old', last_name: 'claim'))
        .save_and_complete_later
      apply_page.start_a_claim
        .register(email_address: email_address, password: 'green')
      claimants_details_page
        .fill_in_all(claimant: build(:ui_claimant, :mandatory))
        .save_and_complete_later
      apply_page.return_to_a_claim
        .reset_memorable_word
        .using(email_address: email_address)
        .assert_memorable_word_email_sent

      perform_active_jobs(ActionMailer::DeliveryJob)

      reset_memorable_word_page.from_email_for(email_address)
        .set_memorable_word('newmemorableword')
        .return_to_your_claim(claim_number: Claim.last.application_reference, memorable_word: 'newmemorableword')
      expect(claimants_details_page).to be_displayed
    end

    it 'provides valid feedback if claim number not given' do
      apply_page.load.return_to_a_claim
        .return_to_your_claim claim_number: nil, memorable_word: 'test'
      return_to_your_claim_page.assert_missing_claim_number
    end
  end
end
