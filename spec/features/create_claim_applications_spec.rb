require 'rails_helper'

feature 'Claim applications', type: :feature do
  include FormMethods
  include Messages
  include PdfMethods
  include MailMatchers
  include ActiveJob::TestHelper
  include ActiveJobPerformHelper

  around { |example| travel_to(Date.new(2014, 9, 29)) { example.run } }
  let(:claim_confirmation_page) { ET1::Test::ClaimConfirmationPage.new }

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

      expect(page).to have_text     "Claim submitted"
      expect(page).not_to have_signout_button
      expect(page).not_to have_session_prompt
    end

    context 'using a stubbed api environment' do
      let(:pdf_url) { 'http://localhost:9000/etapibuckettest/5KL3ugfH8V8DEn7VaTsxZ2Eh?response-content-disposition=attachment%3B%20filename%3D%22et1_first_last.pdf%22%3B%20filename%2A%3DUTF-8%27%27et1_first_last.pdf\u0026X-Amz-Algorithm=AWS4-HMAC-SHA256\u0026X-Amz-Credential=accessKey1%2F20190429%2Fus-east-1%2Fs3%2Faws4_request\u0026X-Amz-Date=20190429T073842Z\u0026X-Amz-Expires=3600\u0026X-Amz-SignedHeaders=host\u0026X-Amz-Signature=4b81e1773553ef2908afa8e61a57a1a6af83a0f9af9a69eea606a6606ca1f15e' }

      let(:et_api_url) { 'http://api.et.net:4000/api/v2' }
      let(:build_claim_url) { "#{et_api_url}/claims/build_claim" }
      let(:create_reference_url) { "#{et_api_url}/references/create_reference" }
      let(:api_create_claim_response) do
        {
          status: 'accepted',
          meta: {
            BuildClaim: {
              reference: '222000000200',
              office: {
                name: 'London Central',
                code: 22,
                telephone: '020 7273 8603',
                address: 'Victory House, 30-34 Kingsway, London WC2B 6EX',
                email: 'londoncentralet@hmcts.gsi.gov.uk'
              },
              pdf_url: pdf_url
            },
            BuildPrimaryRespondent: {},
            BuildPrimaryClaimant: {},
            BuildSecondaryClaimants: {},
            BuildSecondaryRespondents: {},
            BuildPrimaryRepresentative: {}
          },
          uuid: '106144b2-537b-4066-b4bc-2982531d9b9a'
        }      end

      around do |example|
        ClimateControl.modify ET_API_URL: et_api_url do
          stub_request(:post, build_claim_url).with(headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }).to_return(body: api_create_claim_response.to_json, status: 202, headers: { 'Content-Type': 'application/json' })
          stub_request(:post, create_reference_url).with(headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }).to_return(body: { status: 'created', data: { reference: 'somereference', office: { code: '44', name: 'Birmingham', address: { building: '1', street: 'Street', locality: 'Birmingham', county: 'Warwickshire', post_code: 'B1 3AG' } } } }.to_json, status: 201, headers: { 'Content-Type': 'application/json' })
          example.run
        end
      end

      context 'Downloading the PDF' do
        scenario 'when the file is available', js: true do
          complete_a_claim seeking_remissions: true
          click_button 'Submit claim'
          claim_confirmation_page.assert_pdf_url(api_create_claim_response.dig(:meta, :BuildClaim, :pdf_url))
        end

        context 'with a pdf file that isnt ready yet' do
          let(:pdf_url) { "http://something.wrong/invalid.pdf" }

          scenario 'when the file is unavailable', js: true do
            complete_a_claim seeking_remissions: true
            click_button 'Submit claim'

            claim_confirmation_page.assert_invalid_pdf_link
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

        it 'contains the correct reference and address' do
          office = build(:office, be_a_valid_api_command.dig(:meta, :BuildClaim, :office))
          complete_a_claim
          expect(page).to have_text 'Check your claim'
          click_button 'Submit claim', exact: true

          claim_confirmation_page.assert_application_reference
          claim_confirmation_page.assert_office(office)
        end
      end

      context 'Viewing the confirmation page under error conditions' do
        it 'shows the user that the submission is in progress when the request times out' do
          raise "TODO"
        end

        it 'shows the user that something has gone wrong and shows an error reference number if the API rejects the submission' do
          raise "TODO"
        end
      end
    end
  end
end
