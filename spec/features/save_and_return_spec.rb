require 'rails_helper'

feature 'Save and Return', js: true do
  include FormMethods
  include Messages
  include MailMatchers
  include ActiveJob::TestHelper
  include ActiveJobPerformHelper
  let(:ui_claimant) { build(:ui_claimant, :default) }

  scenario 'ending the session actually ends the session' do
    start_claim
    fill_in_password
    claimants_details_page.fill_in_all(claimant: ui_claimant)

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
    claimants_details_page.fill_in_all(claimant: ui_claimant)

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

  scenario 'ending the session when email address previously entered' do
    start_claim
    saving_your_claim_page.register(email_address: FormMethods::SAVE_AND_RETURN_EMAIL, password: 'green')
    claimants_details_page.fill_in_all(claimant: ui_claimant)

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
    claimants_details_page.fill_in_all(claimant: ui_claimant)
    claimants_details_page.save_and_continue
    end_session
    fill_in_return_form Claim.last.reference, 'green'

    expect(page).to have_text(claim_heading_for(:claimant))
    claimants_details_page.about_the_claimant_group.last_name_question.assert_value(ui_claimant.last_name)
  end

  scenario 'returning to an existing application after session expiration' do
    start_claim
    fill_in_password 'green'
    claimants_details_page.fill_in_all(claimant: ui_claimant)
    claimants_details_page.save_and_continue

    travel_to TimeHelper.session_expiry_time do
      fill_in_return_form Claim.last.reference, 'green'
      expect(page).to have_text(claim_heading_for(:claimant))
      claimants_details_page.about_the_claimant_group.last_name_question.assert_value(ui_claimant.last_name)
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
