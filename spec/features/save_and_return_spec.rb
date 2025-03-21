require 'rails_helper'

describe 'Save and Return', :js, type: :feature do
  include FormMethods
  include Messages
  include MailMatchers
  include ActiveJob::TestHelper
  include ActiveJobPerformHelper
  let(:ui_claimant) { build(:ui_claimant, :default) }

  include_context 'fake gov notify'

  it 'ending the session actually ends the session' do
    start_claim
    saving_your_claim_page.register(password: 'green')
    claimants_details_page.fill_in_all(claimant: ui_claimant)

    within 'aside' do
      click_link_or_button 'Save and complete later'
    end

    click_link_or_button 'Sign out now'

    visit claim_claimant_path

    expect(page).to have_no_current_path claim_claimant_path, ignore_query: true
  end

  it 'ending the session with email address' do
    start_claim
    saving_your_claim_page.register(password: 'green')
    claimants_details_page.fill_in_all(claimant: ui_claimant)

    within 'aside' do
      click_link_or_button 'Save and complete later'
    end

    expect(page).to have_text('Claim saved')
    expect(page).not_to have_signout_button
    expect(page).to have_text(Claim.last.reference)

    ActionMailer::Base.deliveries.clear
    fill_in 'Enter your email address to get your claim number emailed to you.',
            with: FormMethods::SAVE_AND_RETURN_EMAIL
    click_link_or_button 'Sign out now'

    perform_active_jobs(ActionMailer::MailDeliveryJob)
    mail = ActionMailer::Base.deliveries.last
    expect(mail).to match_pattern Claim.last.reference

    expect(page).to have_text(claim_heading_for(:new))
  end

  it 'ending the session when email address previously entered', :js do
    start_claim
    saving_your_claim_page.register(email_address: 'mail@example.com', password: 'green')
    claimants_details_page.fill_in_all(claimant: ui_claimant)

    within 'aside' do
      click_link_or_button 'Save and complete later'
    end

    expect(page).to have_text(claim_heading_for(:new))
  end

  it 'ending the session when current page invalid' do
    start_claim
    saving_your_claim_page.register(password: 'green')

    within 'aside' do
      click_link_or_button 'Save and complete later'
    end

    expect(page).to have_text('Claim saved')
    expect(page).not_to have_signout_button
  end

  it 'returning to existing application', :js do
    start_claim
    saving_your_claim_page.register(password: 'green')
    claimants_details_page.fill_in_all(claimant: ui_claimant)
    claimants_details_page.save_and_continue
    group_claims_page.
      save_and_complete_later.
      sign_out_now
    apply_page.
      load.
      return_to_a_claim.
      return_to_your_claim claim_number: Claim.last.reference, memorable_word: 'green'

    expect(page).to have_text(claim_heading_for(:claimant))
    claimants_details_page.about_the_claimant_group.last_name_question.assert_value(ui_claimant.last_name)
  end

  it 'returning to an existing application after session expiration' do
    start_claim
    saving_your_claim_page.register(password: 'green')
    claimants_details_page.fill_in_all(claimant: ui_claimant)
    claimants_details_page.save_and_continue

    travel_to TimeHelper.session_expiry_time do
      fill_in_return_form Claim.last.reference, 'green'
      expect(page).to have_text(claim_heading_for(:claimant))
      claimants_details_page.about_the_claimant_group.last_name_question.assert_value(ui_claimant.last_name)
    end
  end

  it 'returning to the existing application page from the claims details page' do
    start_claim
    saving_your_claim_page.register(password: 'green')
    expect(claimants_details_page).to be_displayed
    page.go_back
    expect(saving_your_claim_page).to be_displayed
    claim = Claim.last
    expect(claim.user.valid_password?('green')).to be true
  end

  it 'returning to the application page shows the correct page numbers' do
    start_claim
    expect(page).to have_text('Page 1 of 11')
    saving_your_claim_page.register(password: 'green')
    expect(page).to have_text('Page 2 of 11')
    page.go_back
    expect(page).to have_text('Page 1 of 11')
  end

  context 'when memorable word not set' do
    it 'returning to an existing application' do
      start_claim
      fill_in_return_form Claim.last.reference, 'memorable word was not set'

      expect(page).to have_text 'Return to your claim'
      expect(page).not_to have_signout_button
    end
  end

  context 'when forgotten memorable word', :js do
    let(:email_address) { 'doesntmatter@example.com' }

    it 'recovers correctly when the email is not used at the beginning but when saved' do

      apply_page.load.start_a_claim.
        register(email_address: nil, password: 'green')
      claimants_details_page.
        fill_in_all(claimant: build(:ui_claimant, :mandatory)).
        save_and_complete_later.
        with(email_address:)
      apply_page.return_to_a_claim.
        reset_memorable_word.
        using(email_address:, claim_number: Claim.last.application_reference).
        assert_memorable_word_email_sent

      perform_active_jobs(ActionMailer::MailDeliveryJob)

      reset_memorable_word_page.from_email_for(email_address).
        set_memorable_word('newmemorableword').
        return_to_your_claim(claim_number: Claim.last.application_reference, memorable_word: 'newmemorableword')
      expect(claimants_details_page).to be_displayed
    end

    it 'recovers correctly when the email used at the beginning' do

      apply_page.load.start_a_claim.
        register(email_address:, password: 'green')
      claimants_details_page.
        fill_in_all(claimant: build(:ui_claimant, :mandatory)).
        save_and_complete_later
      apply_page.return_to_a_claim.
        reset_memorable_word.
        using(email_address:, claim_number: Claim.last.application_reference).
        assert_memorable_word_email_sent

      perform_active_jobs(ActionMailer::MailDeliveryJob)

      reset_memorable_word_page.from_email_for(email_address).
        set_memorable_word('newmemorableword').
        return_to_your_claim(claim_number: Claim.last.application_reference, memorable_word: 'newmemorableword')
      expect(claimants_details_page).to be_displayed
    end

    it 'allows a second claim to be used against the same email' do
      apply_page.load.start_a_claim.
        register(email_address:, password: 'green')
      claimants_details_page.
        fill_in_all(claimant: build(:ui_claimant, :mandatory, first_name: 'old', last_name: 'claim')).
        save_and_complete_later
      apply_page.start_a_claim.
        register(email_address:, password: 'green')
      claimants_details_page.
        fill_in_all(claimant: build(:ui_claimant, :mandatory)).
        save_and_complete_later
      apply_page.return_to_a_claim.
        reset_memorable_word.
        using(email_address:).
        assert_memorable_word_email_sent

      perform_active_jobs(ActionMailer::MailDeliveryJob)

      reset_memorable_word_page.from_email_for(email_address).
        set_memorable_word('newmemorableword').
        return_to_your_claim(claim_number: Claim.last.application_reference, memorable_word: 'newmemorableword')
      expect(claimants_details_page).to be_displayed
    end

    it 'provides valid feedback if claim number not given' do
      apply_page.load.return_to_a_claim.
        return_to_your_claim claim_number: nil, memorable_word: 'test'
      return_to_your_claim_page.assert_missing_claim_number
    end
  end
end
