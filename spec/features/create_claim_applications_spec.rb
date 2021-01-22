require 'rails_helper'

feature 'Claim applications', type: :feature, js: true do
  include FormMethods
  include Messages
  include MailMatchers
  include ActiveJob::TestHelper
  include ActiveJobPerformHelper

  around { |example| travel_to(Date.new(2018, 9, 29)) { example.run } }
  let(:et_api_url) { 'http://api.et.net:4000/api/v2' }
  let(:build_claim_url) { "#{et_api_url}/claims/build_claim" }
  let(:example_pdf_url) { test_valid_pdf_url(host: "#{page.server.host}:#{page.server.port}") }
  let(:ui_claimant) { build(:ui_claimant, :default) }
  let(:ui_secondary_claimants) { build_list(:ui_secondary_claimant, 1, :default) }
  let(:ui_representative) { build(:ui_representative, :default) }
  let(:ui_respondent) { build(:ui_respondent, :default) }
  let(:ui_secondary_respondents) { [] }
  around do |example|
    ClimateControl.modify ET_API_URL: et_api_url do
      example.run
    end
  end
  before do
    essential_response_data = {
      meta: {
        BuildClaim: {
          pdf_url: example_pdf_url,
          reference: "332000121100",
          office: {
            name: "Watford",
            code: 33,
            telephone: "01923 281 750",
            address: "3rd Floor, Radius House, 51 Clarendon Rd, Watford, WD17 1HP",
            email: "watfordet@justice.gov.uk"
          }
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

    scenario 'Create a new application', js: true do
      start_claim
      expect(page).to have_text page_number(1)
      expect(page).to have_text before_you_start_message
      expect(page).not_to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering word for save and return' do
      start_claim
      saving_your_claim_page.register(email_address: nil, password: 'green')

      claim = Claim.last
      expect(claim.user.valid_password?('green')).to be true

      expect(page).to have_text page_number(2)
      expect(page).to have_text claim_heading_for(:claimant)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering word and email for save and return', js: true do
      start_claim
      saving_your_claim_page.register(email_address: FormMethods::SAVE_AND_RETURN_EMAIL, password: 'green')

      claim = Claim.last
      expect(claim.user.valid_password?('green')).to be true

      # Run the active job job
      perform_active_jobs(ActionMailer::DeliveryJob)

      mail = ActionMailer::Base.deliveries.last
      expect(mail).to match_pattern claim.reference

      expect(page).to have_text claim_heading_for(:claimant)
    end

    scenario 'Entering personal details' do
      start_claim
      saving_your_claim_page.register(email_address: nil, password: 'green')
      claimants_details_page.fill_in_all(claimant: ui_claimant)
      claimants_details_page.save_and_continue

      expect(page).to have_text page_number(3)
      expect(page).to have_text claim_heading_for(:additional_claimants)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering additional claimant details' do
      start_claim
      saving_your_claim_page.register(email_address: nil, password: 'green')
      claimants_details_page.fill_in_all(claimant: ui_claimant)
      claimants_details_page.save_and_continue
      group_claims_page.fill_in_all(secondary_claimants: ui_secondary_claimants)
      group_claims_page.save_and_continue

      expect(page).to have_text page_number(4)
      expect(page).to have_text claim_heading_for(:representative)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario "Navigating between manual and CSV upload for additional claimants" do
      start_claim
      saving_your_claim_page.register(email_address: nil, password: 'green')
      claimants_details_page.fill_in_all(claimant: ui_claimant)
      claimants_details_page.save_and_continue
      group_claims_page.provide_spreadsheet

      expect(page).to have_text page_number(3)
      expect(page).to have_text claim_heading_for(:additional_claimants_upload)
      expect(page).to have_signout_button

      group_claims_upload_page.switch_to_manual_input

      expect(page).to have_text page_number(3)
      expect(page).to have_text claim_heading_for(:additional_claimants)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering additional claimant upload details' do
      start_claim
      saving_your_claim_page.register(email_address: nil, password: 'green')
      claimants_details_page.fill_in_all(claimant: ui_claimant)
      claimants_details_page.save_and_continue
      group_claims_page.provide_spreadsheet.no_secondary_claimants.save_and_continue

      expect(page).to have_text page_number(4)
      expect(page).to have_text claim_heading_for(:representative)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering representative details' do
      start_claim
      saving_your_claim_page.register(email_address: nil, password: 'green')
      claimants_details_page.fill_in_all(claimant: ui_claimant)
      claimants_details_page.save_and_continue
      group_claims_page.fill_in_all(secondary_claimants: ui_secondary_claimants)
      group_claims_page.save_and_continue
      representatives_details_page.fill_in_all(representative: ui_representative)
      representatives_details_page.save_and_continue

      expect(page).to have_text page_number(5)
      expect(page).to have_text claim_heading_for(:respondent)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Display ACAS hints', js: true do
      start_claim
      saving_your_claim_page.register(email_address: nil, password: 'green')
      claimants_details_page.fill_in_all(claimant: ui_claimant)
      claimants_details_page.save_and_continue
      group_claims_page.fill_in_all(secondary_claimants: ui_secondary_claimants)
      group_claims_page.save_and_continue
      representatives_details_page.fill_in_all(representative: ui_representative)
      representatives_details_page.save_and_continue
      dont_have_acas_respondent = build(:ui_respondent, :default, :dont_have_acas)
      dont_have_acas_respondent_interim_relief = build(:ui_respondent, :dont_have_acas, :interim_relief)
      respondents_details_page
        .fill_in_all(respondent: dont_have_acas_respondent)
        .assert_correct_hints(dont_have_acas_respondent)
        .fill_in_dont_have_acas_number(dont_have_acas_respondent_interim_relief)
        .assert_correct_hints(dont_have_acas_respondent_interim_relief)
    end

    scenario 'Entering respondent details' do
      start_claim
      saving_your_claim_page.register(email_address: nil, password: 'green')
      claimants_details_page.fill_in_all(claimant: ui_claimant)
      claimants_details_page.save_and_continue
      group_claims_page.fill_in_all(secondary_claimants: ui_secondary_claimants)
      group_claims_page.save_and_continue
      representatives_details_page.fill_in_all(representative: ui_representative)
      representatives_details_page.save_and_continue
      respondents_details_page.fill_in_all(respondent: ui_respondent)
      respondents_details_page.save_and_continue

      expect(page).to have_text page_number(6)
      expect(page).to have_text claim_heading_for(:additional_respondents)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering additional respondent details' do
      start_claim
      saving_your_claim_page.register(email_address: nil, password: 'green')
      claimants_details_page.fill_in_all(claimant: ui_claimant)
      claimants_details_page.save_and_continue
      group_claims_page.fill_in_all(secondary_claimants: ui_secondary_claimants)
      group_claims_page.save_and_continue
      representatives_details_page.fill_in_all(representative: ui_representative)
      representatives_details_page.save_and_continue
      #fill_in_representative_details
      respondents_details_page.fill_in_all(respondent: ui_respondent)
      respondents_details_page.save_and_continue
      additional_respondents_page.no_secondary_respondents
      additional_respondents_page.save_and_continue

      expect(page).to have_text page_number(7)
      expect(page).to have_text claim_heading_for(:employment)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering employment details' do
      start_claim
      saving_your_claim_page.register(email_address: nil, password: 'green')
      claimants_details_page.fill_in_all(claimant: ui_claimant)
      claimants_details_page.save_and_continue
      group_claims_page.fill_in_all(secondary_claimants: ui_secondary_claimants)
      group_claims_page.save_and_continue
      representatives_details_page.fill_in_all(representative: ui_representative)
      representatives_details_page.save_and_continue
      respondents_details_page.fill_in_all(respondent: ui_respondent)
      respondents_details_page.save_and_continue
      additional_respondents_page.fill_in_all(secondary_respondents: ui_secondary_respondents)
      additional_respondents_page.save_and_continue

      expect(page).to have_text page_number(8)
      expect(page).to have_text claim_heading_for(:claim_type)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering claim type details' do
      start_claim

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
      complete_a_claim
      deselect_claimant_email
      deselect_representative_email
      click_button 'Submit claim'

      expect(Claim.last.confirmation_email_recipients).to be_empty
    end

    scenario 'Submitting the claim' do
      complete_a_claim
      click_button 'Submit claim'

      expect(page).to have_text "Claim submitted"
      expect(page).to have_text "Watford, watfordet@justice.gov.uk, 01923 281 750"
      expect(page).not_to have_signout_button
      expect(page).not_to have_session_prompt
    end

    scenario 'attempting a new claim after submission' do
      complete_a_claim
      click_button 'Submit claim'

      expect(page).to have_text "Claim submitted"
      claim_submitted_page.home
      apply_page.start_a_claim
      expect(saving_your_claim_page).to be_displayed
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
                                    "allow_video_attendance" => true,
                                    "gender" => "Male",
                                    "date_of_birth" => "1985-01-15",
                                    "special_needs" => "I am blind."
      end).to have_been_made
    end

    context 'Downloading the PDF', js: true do
      scenario 'when the file is available' do
        complete_a_claim
        click_button 'Submit claim'
        expect(claim_submitted_page).to have_save_a_copy_link
      end

      context 'with pdf not ready yet' do
        let(:example_pdf_url) { test_invalid_pdf_url(host: "#{page.server.host}:#{page.server.port}") }

        scenario 'when the file is unavailable' do
          complete_a_claim
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
