# coding: utf-8
require 'rails_helper'

RSpec.feature 'Confirmation page', type: :feature do
  include FormMethods

  before do
    visit new_user_session_path
    fill_in_return_form claim.reference, 'lollolol'

    visit claim_review_path
    click_button 'Submit'
  end

  around do |example|
    travel_to(Time.new 2014) { example.run }
  end

  context 'when payment fails' do
    let(:claim) do
      create :claim, :not_submitted, :no_fee_group_reference, :payment_no_remission_payment_failed
    end

    scenario 'viewing the confirmation page' do
      expect(page).to have_text 'We’ll contact you within 5 working days to arrange payment.'
      expect(page).to have_text 'Issue fee paid' 'Unable to process payment'

      expect(page).to have_link 'Save a copy', href: pdf_path
      expect(page).not_to have_signout_button
      expect(page).not_to have_session_prompt
    end
  end

  context 'when payment is successful' do
    let(:claim) { create :claim, :not_submitted, :payment_no_remission }

    before { complete_payment }

    scenario 'viewing the confirmation page' do
      expect(page).to_not have_text 'We’ll contact you within 5 working days to arrange payment.'
      expect(page).to_not have_link 'Complete an application for help with fees'

      expect(page).to have_link 'Save a copy', href: pdf_path
      expect(page).to have_text 'Claim submitted' 'Submitted 01 January 2014 to tribunal office Birmingham, Centre City Tower, 5­7 Hill Street, Birmingham B5 4UU'
      expect(page).to have_text 'Issue fee paid' '£250.00'
      expect(page).to_not have_text 'If you have any questions, contact the Public Enquiry Line'

      expect(page).not_to have_signout_button
      expect(page).not_to have_session_prompt
    end
  end

  context 'single claimant' do
    context 'when remission is sought' do
      let(:claim) { create :claim, :single_claimant, :not_submitted, :remission_only }

      scenario 'viewing the confirmation page' do

        expect(page).to have_text 'You have started an application for help with fees. You must now complete your application within 7 days or your claim may be rejected.'
        expect(page).to have_link 'Complete an application for help with fees', href: 'https://gov.uk/help-with-court-fees'

        expect(page).to have_link 'Save a copy', href: pdf_path
        expect(page).to have_text 'Claim submitted'
        expect(page).to_not have_text 'Submitted 01 January 2014 to tribunal office Birmingham, Centre City Tower, 5­7 Hill Street, Birmingham B5 4UU'
        expect(page).to_not have_text 'Issue fee paid'
        expect(page).to have_text 'If you have any questions, contact the Public Enquiry Line'

        expect(page).not_to have_signout_button
        expect(page).not_to have_session_prompt
      end
    end
  end

  context 'multiple claimants' do
    context 'when partial remission is sought' do
      let(:claim) { create :claim, :not_submitted, :group_payment_with_remission_payment_failed }

      before { complete_payment }

      scenario 'viewing the confirmation page' do

        expect(page).to have_text 'You have started an application for help with fees. You must now complete your application within 7 days or your claim may be rejected.'
        expect(page).to have_link 'Complete an application for help with fees', href: 'https://gov.uk/help-with-court-fees'

        expect(page).to have_link 'Save a copy', href: pdf_path
        expect(page).to have_text 'Issue fee paid' '£250.00'
        expect(page).to have_text 'If you have any questions, contact the Public Enquiry Line'

        expect(page).not_to have_signout_button
        expect(page).not_to have_session_prompt
      end
    end
  end
end
