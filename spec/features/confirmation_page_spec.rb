require 'rails_helper'

feature 'Confirmation page' do
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
    end
  end

  context 'when payment is successful' do
    let(:claim) do
      create :claim, :not_submitted, :payment_no_remission_payment_failed
    end

    before { complete_payment }

    scenario 'viewing the confirmation page' do
      expect(page).to_not have_text 'We’ll contact you within 5 working days to arrange payment.'
      expect(page).to_not have_link 'Apply for fee remission'

      expect(page).to have_text 'Claim submitted' 'Submitted 01 January 2014 to tribunal office Birmingham, Centre City Tower, 5­7 Hill Street, Birmingham B5 4UU'
      expect(page).to have_text 'Issue fee paid' '£250.00'
      expect(page).to_not have_text 'If you have any questions, contact the Public Enquiry Line'
    end
  end

  context 'single claimant' do
    context 'when remission is sought' do
      let(:claim) { create :claim, :not_submitted, :remission_only }

      scenario 'viewing the confirmation page' do
        expect(page).to have_text 'You have started an application for fee remission. You must complete your application within 7 days or your claim may be rejected.'
        expect(page).to have_link 'Apply for fee remission'
        expect(page).to have_text 'We’ll review your claim for remission and contact you to explain the next steps.'

        expect(page).to have_text 'Claim submitted'
        expect(page).to_not have_text 'Submitted 01 January 2014 to tribunal office Birmingham, Centre City Tower, 5­7 Hill Street, Birmingham B5 4UU'

        expect(page).to_not have_text 'Issue fee paid'

        expect(page).to have_text 'If you have any questions, contact the Public Enquiry Line'

      end
    end
  end

  context 'multiple claimants' do
    context 'when partial remission is sought' do
      let(:claim) do
        create :claim, :not_submitted, :group_payment_with_remission_payment_failed
      end

      before { complete_payment }

      scenario 'viewing the confirmation page' do
        expect(page).to have_text 'You have started an application for fee remission. You must complete your application within 7 days or your claim may be rejected.'
        expect(page).to have_link 'Apply for fee remission'
        expect(page).to have_text 'We’ll review your claim for remission and contact you to explain the next steps.'

        expect(page).to have_text 'Issue fee paid' '£250.00'
        expect(page).to have_text 'If you have any questions, contact the Public Enquiry Line'
      end
    end
  end
end
