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

    describe 'when a callback hits the success endpoint' do
      context 'with a successful response' do
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

      context 'with an uncertain payment status' do
        context 'with a 52: authorisation unknown status' do
          it 'logs an event with a message' do
            expect(claim).to receive(:create_event).
              with 'payment_uncertain', message: /Status 52: Authorisation Not Known/

            get :success,
              'orderID' => '511234567800',
              'amount' => '250',
              'PM' => 'CreditCard',
              'ACCEPTANCE' => 'test123',
              'STATUS' => '52',
              'CARDNO' => 'XXXXXXXXXXXX111',
              'TRXDATE' => '09/15/14',
              'PAYID' => '34707458',
              'NCERROR' => '0',
              'BRAND' => 'VISA',
              'SHASIGN' => '05D8A34BA87286420FB2FCBEE78DB1223FB241505CBA8DAED09D3D384235CAD2'
          end
        end

        context 'with a 92: payment uncertain status' do
          it 'logs an event with a message' do
            expect(claim).to receive(:create_event).
              with 'payment_uncertain', message: /Status 92: Payment Uncertain/

            get :success,
              'orderID' => '511234567800',
              'amount' => '250',
              'PM' => 'CreditCard',
              'ACCEPTANCE' => 'test123',
              'STATUS' => '92',
              'CARDNO' => 'XXXXXXXXXXXX111',
              'TRXDATE' => '09/15/14',
              'PAYID' => '34707458',
              'NCERROR' => '0',
              'BRAND' => 'VISA',
              'SHASIGN' => '5C4888CBF89FD8005B22E106D8F3F1CD3453982D7475E78F724BB0951C27C27F'
          end
        end

        context 'with an unrecognized response status' do
          it 'logs an event with a message containing the status code' do
            expect(claim).to receive(:create_event).
              with 'payment_uncertain', message: /Status Code: 999/

            get :success,
              'orderID' => '511234567800',
              'amount' => '250',
              'PM' => 'CreditCard',
              'ACCEPTANCE' => 'test123',
              'STATUS' => '999',
              'CARDNO' => 'XXXXXXXXXXXX111',
              'TRXDATE' => '09/15/14',
              'PAYID' => '34707458',
              'NCERROR' => '0',
              'BRAND' => 'VISA',
              'SHASIGN' => '2DD49AE6327E81A8CF8ADF95165BB440E28A6F4B21F9CF4EA83CC7CBBFB76D18'
          end
        end
      end
    end

    describe 'when a callback hits the decline endpoint' do
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

        it 'payment_response is not valid' do
          payment_response = instance_double('PaymentGateway::Response', valid?: false)
          allow(controller).to receive(:payment_response).and_return payment_response
          message = "Failed to recognize payment order: 511234567800, status: 9"
          expect(Raven).to receive(:capture_exception).with(message)

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
end
