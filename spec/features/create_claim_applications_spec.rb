require 'rails_helper'

feature 'Claim applications', type: :feature do
  include FormMethods
  include Messages
  include PdfMethods

  context 'along the happy path' do
    scenario 'Create a new application' do
      start_claim
      expect(page).to have_text page_number(1)
      expect(page).to have_text before_you_start_message
    end

    scenario 'Entering word for save and return' do
      start_claim
      expect(page).to_not have_button('Complete later')
      fill_in_password 'green'

      claim = Claim.last
      expect(claim.authenticate 'green').to eq(claim)

      expect(page).to have_text page_number(2)
      expect(page).to have_text claim_heading_for(:claimant)
      expect(page).to have_link('Save and complete later')
    end

    scenario 'Entering word and email for save and return' do
      start_claim
      fill_in_password_and_email('green',
        FormMethods::SAVE_AND_RETURN_EMAIL,
        "application_number_email_address")

      claim = Claim.last
      expect(claim.authenticate 'green').to eq(claim)

      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to include(claim.reference)

      expect(page).to have_text claim_heading_for(:claimant)
    end

    scenario 'Entering personal details' do
      start_claim
      fill_in_password
      fill_in_personal_details

      expect(page).to have_text page_number(3)
      expect(page).to have_text claim_heading_for(:additional_claimants)
    end

    scenario 'Entering additional claimant details' do
      start_claim
      fill_in_password
      fill_in_personal_details
      fill_in_additional_claimant_details

      expect(page).to have_text page_number(4)
      expect(page).to have_text claim_heading_for(:representative)
    end

    scenario "Navigating between manual and CSV upload for additional claimants" do
      start_claim
      fill_in_password
      fill_in_personal_details
      fill_in_additional_claimant_jump_to_csv_upload

      expect(page).to have_text page_number(3)
      expect(page).to have_text claim_heading_for(:additional_claimants_upload)

      click_link "manually"

      expect(page).to have_text page_number(3)
      expect(page).to have_text claim_heading_for(:additional_claimants)
    end

    scenario 'Entering additional claimant upload details' do
      start_claim
      fill_in_password
      fill_in_personal_details
      fill_in_additional_claimant_jump_to_csv_upload
      fill_in_additional_claimants_upload_details

      expect(page).to have_text page_number(4)
      expect(page).to have_text claim_heading_for(:representative)
    end

    scenario 'Entering representative details' do
      start_claim
      fill_in_password
      fill_in_personal_details
      fill_in_additional_claimant_details
      fill_in_representative_details

      expect(page).to have_text page_number(5)
      expect(page).to have_text claim_heading_for(:respondent)
    end

    scenario 'Entering respondent details' do
      start_claim
      fill_in_password
      fill_in_personal_details
      fill_in_additional_claimant_details
      fill_in_representative_details
      fill_in_respondent_details

      expect(page).to have_text page_number(6)
      expect(page).to have_text claim_heading_for(:additional_respondents)
    end

    scenario 'Entering additional respondent details' do
      start_claim
      fill_in_password
      fill_in_personal_details
      fill_in_additional_claimant_details
      fill_in_representative_details
      fill_in_respondent_details
      fill_in_additional_respondent_details

      expect(page).to have_text page_number(7)
      expect(page).to have_text claim_heading_for(:employment)
    end

    scenario 'Entering employment details' do
      start_claim
      fill_in_password
      fill_in_personal_details
      fill_in_additional_claimant_details
      fill_in_representative_details
      fill_in_respondent_details
      fill_in_additional_respondent_details
      fill_in_employment_details

      expect(page).to have_text page_number(8)
      expect(page).to have_text claim_heading_for(:claim_type)
    end

    scenario 'Entering claim type details' do
      fill_in_pre_claim_pages
      fill_in_claim_type_details

      expect(page).to have_text page_number(9)
      expect(page).to have_text claim_heading_for(:claim_details)
    end

    scenario 'Entering claim details' do
      fill_in_pre_claim_pages
      fill_in_claim_type_details
      fill_in_claim_details

      expect(page).to have_text page_number(10)
      expect(page).to have_text claim_heading_for(:claim_outcome)
    end

    scenario 'Entering claim outcome details' do
      fill_in_pre_claim_pages
      fill_in_claim_type_details
      fill_in_claim_details
      fill_in_claim_outcome_details

      expect(page).to have_text page_number(11)
      expect(page).to have_text claim_heading_for(:additional_information)
    end

    scenario 'Entering additonal information' do
      fill_in_pre_claim_pages
      fill_in_claim_type_details
      fill_in_claim_details
      fill_in_claim_outcome_details
      fill_in_addtional_information

      expect(page).to have_text page_number(12)
      expect(page).to have_text claim_heading_for(:your_fee)
    end

    scenario 'Entering your fee details' do
      fill_in_pre_claim_pages
      fill_in_claim_type_details
      fill_in_claim_details
      fill_in_claim_outcome_details
      fill_in_addtional_information
      fill_in_your_fee

      expect(page).to have_text review_heading_for(:show)
    end

    scenario 'Emailing confirmation' do
      complete_a_claim seeking_remissions: true
      select_recipients

      email = ActionMailer::Base.deliveries.last

      expect(email.to).to eq [FormMethods::CLAIMANT_EMAIL, FormMethods::REPRESENTATIVE_EMAIL]
      expect(email.parts.first.body).to include 'Application complete'
      expect(email.parts.last.content_type).
        to eq "application/pdf; charset=UTF-8; filename=et1_barrington_wrigglesworth.pdf"
    end

    scenario 'Submitting claim when no email addresses' do
      ActionMailer::Base.deliveries = []
      complete_a_claim seeking_remissions: true, claimant_email: false
      click_button 'Submit the form'

      expect(ActionMailer::Base.deliveries.size).to eq 0

      expect(page.title).to include 'Application complete'
    end

    scenario 'Submitting the claim when payment is not required' do
      complete_a_claim seeking_remissions: true
      click_button 'Submit the form'

      expect(page).to have_text     "Application complete"
      expect(page).not_to have_text "Fee paid"
      expect(page).not_to have_text "Fee to pay"
      expect(page).to have_text     "Get help with paying your fee now"
    end

    scenario 'Downloading the PDF' do
      complete_a_claim seeking_remissions: true
      click_button 'Submit the form'
      click_link 'Download your application'

      expect(page.response_headers['Content-Type']).to eq "application/pdf"
      expect(pdf_to_hash(page.body)).to eq(YAML.load(File.read('spec/support/et1_pdf_example.yml')))
    end

    scenario 'Viewing the confirmation page when seeking remission' do
      complete_a_claim seeking_remissions: true
      click_button 'Submit the form'

      expect(page).to have_text 'Get help with paying your fee now'
      expect(page).not_to have_text 'From the information you’ve given us, you have to pay'
    end

    scenario 'Viewing the confirmation page when not seeking remission' do
      complete_a_claim seeking_remissions: false
      click_button 'Submit the form'

      expect(page).not_to have_text 'Get help with paying your fee now'
      expect(page).to have_text 'From the information you’ve given us, you have to pay'
    end
  end
end
