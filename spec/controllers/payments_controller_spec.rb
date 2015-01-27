require 'rails_helper'

RSpec.describe PaymentsController do
  # The majority of this controller is tested in the feature spec. This spec
  # is just for event logging

  let(:claim) { create :claim, fee_group_reference: '511234567800', state: 'payment_required' }

  describe 'logging events' do
    before do
      # Don't want the job immediately 'submitting' the thing
      allow(ClaimSubmissionJob).to receive(:perform_later)
      allow(Claim).to receive(:find_by).
        with(fee_group_reference: '511234567800').
        and_return claim

      allow(claim).to receive_messages(create_payment: true, enqueue!: true)
    end

    context 'for a successful payment' do
      it 'logs an event' do
        expect(claim).to receive(:create_event).with 'payment_received'

        get :success,
          'orderID' => '511234567800',
          'amount' => '250',
          'PM' => 'CreditCard',
          'ACCEPTANCE' => 'test123',
          'STATUS' => '9',
          'CARDNO' => 'XXXXXXXXXXXX111',
          'TRXDATE' => '09/15/14',
          'PAYID' => '34707458',
          'NCERROR' => '0',
          'BRAND' => 'VISA',
          'SHASIGN' => 'A8410E130DA5C6AB210CF8E64CAFA64EC8AC8EFF0D958AC0D2CB3AF3EE467E75'
      end
    end

    context 'for a failed payment' do
      it 'logs an event' do
        expect(claim).to receive(:create_event).with 'payment_declined'

        get :decline,
          'orderID' => '511234567800',
          'amount' => '250',
          'PM' => 'CreditCard',
          'ACCEPTANCE' => 'test123',
          'STATUS' => '9',
          'CARDNO' => 'XXXXXXXXXXXX111',
          'TRXDATE' => '09/15/14',
          'PAYID' => '34707458',
          'NCERROR' => '0',
          'BRAND' => 'VISA',
          'SHASIGN' => 'A8410E130DA5C6AB210CF8E64CAFA64EC8AC8EFF0D958AC0D2CB3AF3EE467E75'
      end
    end
  end
end
