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

  context 'when payment is skipped' do
    let(:claim) { create :claim, :not_submitted, :payment_no_remission }

    scenario 'viewing the confirmation page' do
      expect(page).to_not have_text 'We’ll contact you within 5 working days to arrange payment.'
      expect(page).to_not have_link 'Complete an application for help with fees'

      expect(page).to have_link 'Save a copy', href: pdf_path
      expect(page).to have_text 'Claim submitted' 'Submitted 01 January 2014 to tribunal office Birmingham, Centre City Tower, 5­7 Hill Street, Birmingham B5 4UU'
      expect(page).not_to have_text 'Issue fee paid' '£250.00'
      expect(page).not_to have_text 'If you have any questions, contact the Public Enquiry Line'

      expect(page).not_to have_signout_button
      expect(page).not_to have_session_prompt
    end
  end
end
