require 'rails_helper'

feature 'Payments:', type: :feature, focus: true do
  include FormMethods
  include EpdqMatchers

  before do
    complete_a_claim seeking_remissions: false
    click_button 'Submit the form'
  end

  let(:claim) { Claim.last }

  describe 'the payment page' do
    it 'contains a form to take the user to the payment gateway' do
      expect(page).to have_epdq_form
    end
  end

  describe 'returning from the payment gateway' do
    context 'successfully' do
      before { complete_payment }

      it 'redirects to the confirmation page and displays the fee paid' do
        expect(page).to have_text 'Issue fee paid' '£250.00'
      end

      it 'enqueues the claim for submission' do
        expect(claim).to be_enqueued_for_submission
      end
    end

    context 'unsuccessfully' do
      before { complete_payment(gateway_response: 'decline') }

      it 'redirects to the payment page with an error message' do
        expect(page.current_path).to eq claim_payment_path
        expect(page).to have_text 'Payment declined'
      end

      it 'increments the claim fee group reference' do
        expect(claim.fee_group_reference).to end_with('-1')
      end

      it 'does not enqueue the claim for submission' do
        expect(claim).to be_payment_required
      end
    end
  end

  describe 'poking around the payment callback endpoints' do
    describe 'the success endpoint' do
      before { visit success_claim_payment_path }

      it "returns an empty body when the request isn't properly signed" do
        expect(page.body).to be_empty
      end

      it 'does not enqueue the claim for submission' do
        expect(claim).to be_payment_required
      end
    end

    describe 'the error endpoint' do
      before { visit decline_claim_payment_path }

      it "returns an empty body when the request isn't properly signed" do
        expect(page.body).to be_empty
      end

      it 'does not enqueue the claim for submission' do
        expect(claim).to be_payment_required
      end
    end
  end
end
