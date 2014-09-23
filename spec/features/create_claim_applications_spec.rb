require 'rails_helper'

feature 'Claim applications', type: :feature do
  include FormMethods
  include Messages
  include EpdqMatchers

  context 'along the happy path' do
    before do
      stub_request(:post, 'https://etapi.employmenttribunals.service.gov.uk/1/fgr-office').
        with(postcode: 'AT1 4PQ').to_return body: fgr_response.to_json
    end

    around do |example|
      stub_request(:get, "https://mdepayments.epdq.co.uk/ncol/test/backoffice?BRANDING=EPDQ&lang=1").
        to_return(:status => 200, :body => "", :headers => {})

      PaymentGateway::TASK.run
      example.run
      PaymentGateway::TASK.stop
    end

    let(:fgr_response) do
      {
        "fgr"               => 511234567800,
        "ETOfficeCode"      => 22,
        "ETOfficeName"      => "Birmingham",
        "ETOfficeAddress"   => "Centre City Tower, 5­7 Hill Street, Birmingham B5 4UU",
        "ETOfficeTelephone" => "0121 600 7780"
      }
    end

    scenario 'Create a new application' do
      start_claim
      expect(page).to have_text claim_heading_for(:password)
    end

    scenario 'Entering word for save and return' do
      start_claim
      expect(page).to_not have_button('Complete later')
      fill_in_password 'green'

      claim = Claim.first
      expect(claim.authenticate 'green').to eq(claim)

      expect(page).to have_text claim_heading_for(:claimant)
      expect(page).to have_button('Complete later')
    end

    scenario 'Entering word and email for save and return' do
      start_claim
      fill_in_password_and_email 'green', 'mail@example.com'

      claim = Claim.first
      expect(claim.authenticate 'green').to eq(claim)

      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to include(claim.reference)

      expect(page).to have_text claim_heading_for(:claimant)
    end

    scenario 'Entering personal details' do
      start_claim
      fill_in_password
      fill_in_personal_details

      expect(page).to have_text claim_heading_for(:representative)
    end

    scenario 'Entering representative details' do
      start_claim
      fill_in_password
      fill_in_personal_details
      fill_in_representative_details

      expect(page).to have_text claim_heading_for(:respondent)
    end

    scenario 'Entering employer details' do
      start_claim
      fill_in_password
      fill_in_personal_details
      fill_in_representative_details
      fill_in_employer_details

      expect(page).to have_text claim_heading_for(:employment)
    end

    scenario 'Entering employment details' do
      start_claim
      fill_in_password
      fill_in_personal_details
      fill_in_representative_details
      fill_in_employer_details
      fill_in_employment_details

      expect(page).to have_text claim_heading_for(:claim)
    end

    scenario 'Entering claim details' do
      complete_a_claim

      expect(page).to have_text review_heading_for(:show)
    end

    scenario 'Emailing confirmation' do
      complete_a_claim seeking_remissions: false
      select_recipients

      claim = Claim.last

      email = ActionMailer::Base.deliveries.last
      expect(email.to).to eq [FormMethods::CLAIMANT_EMAIL, FormMethods::REPRESENTATIVE_EMAIL, 'bob@example.com', 'jane@example.com']
      expect(email.body).to include completion_message(claim.reference)
    end

    scenario 'Submitting the claim when payment is not required' do
      complete_a_claim
      click_button 'Submit the form'

      expect(page).to have_text "It looks like you haven't paid yet. We'll give you a bell about that soon"
      expect(page).to have_text "Insert instructions on how to claim remission."
    end

    scenario 'Making payment' do
      complete_a_claim seeking_remissions: false
      click_button 'Submit the form'

      expect(page).to have_epdq_form
    end

    scenario 'Returning from the payment page' do
      complete_a_claim seeking_remissions: false
      click_button 'Submit the form'

      return_from_payment_gateway

      expect(page).to have_text 'It looks like you paid.'
      expect(page).to have_text 'No remissions for you. Sorry buddy.'
    end
  end
end
