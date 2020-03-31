require 'rails_helper'

feature 'Claim applications', type: :feature, js: true do
  include FormMethods
  include Messages
  include MailMatchers
  include ActiveJob::TestHelper
  include ActiveJobPerformHelper

  around { |example| travel_to(Date.new(2014, 9, 29)) { example.run } }
  let(:et_api_url) { 'http://api.et.net:4000/api/v2' }
  let(:build_claim_url) { "#{et_api_url}/claims/build_claim" }
  let(:example_pdf_url) { test_valid_pdf_url(host: "#{page.server.host}:#{page.server.port}") }
  around do |example|
    ClimateControl.modify ET_API_URL: et_api_url do
      example.run
    end
  end
  before do
    essential_response_data = {
      meta: {
        BuildClaim: {
          pdf_url: example_pdf_url
        }
      }
    }
    stub_request(:post, build_claim_url).with(headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }).to_return do |request|
      { body: essential_response_data.to_json, headers: { 'Content-Type': 'application/json' } }
    end
  end


  context 'along the happy path' do
    scenario 'Hitting the start page' do
      visit '/'
      expect(page).not_to have_signout_button
      expect(page).not_to have_session_prompt
    end

    scenario 'Create a new application' do
      start_claim
      expect(page).to have_text page_number(1)
      expect(page).to have_text before_you_start_message
      expect(page).not_to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering word for save and return' do
      start_claim
      fill_in_password 'green'

      claim = Claim.last
      expect(claim.authenticate('green')).to eq(claim)

      expect(page).to have_text page_number(2)
      expect(page).to have_text claim_heading_for(:claimant)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering word and email for save and return' do
      start_claim
      fill_in_password_and_email('green',
                                 FormMethods::SAVE_AND_RETURN_EMAIL,
                                 "application_number_email_address")

      claim = Claim.last
      expect(claim.authenticate('green')).to eq(claim)

      # Run the active job job
      perform_active_jobs(ActionMailer::DeliveryJob)

      mail = ActionMailer::Base.deliveries.last
      expect(mail).to match_pattern claim.reference

      expect(page).to have_text claim_heading_for(:claimant)
    end

    scenario 'Entering personal details' do
      start_claim
      fill_in_password
      fill_in_personal_details

      expect(page).to have_text page_number(3)
      expect(page).to have_text claim_heading_for(:additional_claimants)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering additional claimant details' do
      start_claim
      fill_in_password
      fill_in_personal_details
      fill_in_additional_claimant_details

      expect(page).to have_text page_number(4)
      expect(page).to have_text claim_heading_for(:representative)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario "Navigating between manual and CSV upload for additional claimants" do
      start_claim
      fill_in_password
      fill_in_personal_details
      fill_in_additional_claimant_jump_to_csv_upload

      expect(page).to have_text page_number(3)
      expect(page).to have_text claim_heading_for(:additional_claimants_upload)
      expect(page).to have_signout_button

      click_link "manually"

      expect(page).to have_text page_number(3)
      expect(page).to have_text claim_heading_for(:additional_claimants)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering additional claimant upload details' do
      start_claim
      fill_in_password
      fill_in_personal_details
      fill_in_additional_claimant_jump_to_csv_upload
      fill_in_additional_claimants_upload_details

      expect(page).to have_text page_number(4)
      expect(page).to have_text claim_heading_for(:representative)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering representative details' do
      start_claim
      fill_in_password
      fill_in_personal_details
      fill_in_additional_claimant_details
      fill_in_representative_details

      expect(page).to have_text page_number(5)
      expect(page).to have_text claim_heading_for(:respondent)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Display ACAS hints', js: true do
      start_claim
      fill_in_password
      fill_in_personal_details
      fill_in_additional_claimant_details
      fill_in_representative_details

      check "I don’t have an Acas number"

      within('form#edit_respondent') do
        within('.acas .panel-indent') do
          expect(page).to have_text 'Please note: Incorrectly claiming an exemption may lead to your claim being rejected. If in doubt, please contact ACAS.'
          expect(page).not_to have_text 'Please note: This is a rare type of claim. The fact that you are making a claim of unfair dismissal does not mean you are necessarily making a claim for interim relief.'
          choose 'respondent_no_acas_number_reason_interim_relief'
          expect(page).to have_text 'Please note: This is a rare type of claim. The fact that you are making a claim of unfair dismissal does not mean you are necessarily making a claim for interim relief.'
        end
      end
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
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
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
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
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
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering claim type details' do
      fill_in_pre_claim_pages
      fill_in_claim_type_details

      expect(page).to have_text page_number(9)
      expect(page).to have_text claim_heading_for(:claim_details)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering claim details' do
      fill_in_pre_claim_pages
      fill_in_claim_type_details
      fill_in_claim_details

      expect(page).to have_text page_number(10)
      expect(page).to have_text claim_heading_for(:claim_outcome)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering claim outcome details' do
      fill_in_pre_claim_pages
      fill_in_claim_type_details
      fill_in_claim_details
      fill_in_claim_outcome_details

      expect(page).to have_text page_number(11)
      expect(page).to have_text claim_heading_for(:additional_information)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering additonal information' do
      fill_in_pre_claim_pages
      fill_in_claim_type_details
      fill_in_claim_details
      fill_in_claim_outcome_details
      fill_in_addtional_information

      expect(page).not_to have_text claim_heading_for(:your_fee)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering your fee details' do
      fill_in_pre_claim_pages
      fill_in_claim_type_details
      fill_in_claim_details
      fill_in_claim_outcome_details
      fill_in_addtional_information

      expect(page).to have_text review_heading_for(:show)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Signout from claim review page' do
      complete_a_claim

      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Saving the confirmation email recipients' do
      complete_a_claim
      click_button 'Submit claim'

      expect(Claim.last.confirmation_email_recipients).
        to eq [FormMethods::CLAIMANT_EMAIL, FormMethods::REPRESENTATIVE_EMAIL]
    end

    scenario 'Deselecting email confirmation recipients before submission' do
      complete_a_claim seeking_remissions: true
      deselect_claimant_email
      deselect_representative_email
      click_button 'Submit claim'

      expect(Claim.last.confirmation_email_recipients).to be_empty
    end

    scenario 'Submitting the claim' do
      complete_a_claim
      click_button 'Submit claim'

      expect(page).to have_text "Claim submitted"
      expect(page).not_to have_signout_button
      expect(page).not_to have_session_prompt
    end

    scenario 'Validating the API calls claimant data' do
      complete_a_claim
      click_button 'Submit claim'
      expect(a_request(:post, build_claim_url).
        with do |request|
        claimant = JSON.parse(request.body)['data'].detect { |cmd| cmd['command'] == 'BuildPrimaryClaimant' }['data']
        expect(claimant).to include "title" => "Mr",
                                    "first_name" => "Barrington",
                                    "last_name" => "Wrigglesworth",
                                    "address_attributes" => a_hash_including(
                                      "building" => "1",
                                      "street" => "High street",
                                      "locality" => "Anytown",
                                      "county" => "Anyfordshire",
                                      "post_code" => "AT1 4PQ",
                                      "country" => "United Kingdom"
                                    ),
                                    "address_telephone_number" => "01234567890",
                                    "mobile_number" => "07956000000",
                                    "email_address" => "barrington@example.com",
                                    "contact_preference" => "Email",
                                    "gender" => "Male",
                                    "date_of_birth" => "1985-01-15",
                                    "special_needs" => "I am blind."
      end).to have_been_made
    end

    context 'Downloading the PDF', js: true do
      scenario 'when the file is available' do
        complete_a_claim seeking_remissions: true
        click_button 'Submit claim'
        expect(claim_submitted_page).to have_save_a_copy_link
      end

      context 'with pdf not ready yet' do
        let(:example_pdf_url) { test_invalid_pdf_url(host: "#{page.server.host}:#{page.server.port}") }

        scenario 'when the file is unavailable' do
          complete_a_claim seeking_remissions: true
          click_button 'Submit claim'
          expect(claim_submitted_page).to have_invalid_save_a_copy_link
        end
      end
    end

    context 'Viewing the confirmation page' do
      scenario 'with a single claimant without remission option' do
        complete_a_claim
        expect(page).to have_text 'Check your claim'

        within(:xpath, './/div[@class="main-content"]') do
          expect(page).not_to have_text 'Your fee'
          expect(page).not_to have_text 'Help with fees'
        end

        click_button 'Submit claim', exact: true
        expect(page).to have_text 'Claim submitted'
      end
    end
  end
end
