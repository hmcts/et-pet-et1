require 'rails_helper'

RSpec.describe PaymentGateway::Response, type: :service do
  let(:request) { instance_double 'PaymentGateway::Request', query_string: query_string }
  let(:query_string) do
    'orderID=1f7b4bac6daef&amount=250&PM=CreditCard&ACCEPTANCE=test123&STATUS=9' \
      '&CARDNO=XXXXXXXXXXXX1111&TRXDATE=09%2F15%2F14&PAYID=34707458&NCERROR=0&' \
      'BRAND=VISA&SHASIGN=C95AAF23367B016E43D2B6E99C655B0BEE943B6AD66AA262DD0469CE51E5B084'
  end

  let(:payment_gateway_response) { described_class.new request }

  before { allow(EPDQ).to receive(:sha_out).and_return 'LOL soooo secure' }

  describe '#valid?' do
    context 'with a valid signature' do
      it 'returns true' do
        expect(payment_gateway_response.valid?).to be true
      end
    end

    context 'with an invalid signature' do
      before { query_string.sub!(/(?<=SHASIGN=)\w+/, 'lol') }

      it 'returns false' do
        expect(payment_gateway_response.valid?).to be false
      end
    end

    context 'with no signature' do
      before { query_string.sub!(/SHASIGN=\w+/, '') }

      it 'does not raise an exception' do
        expect { payment_gateway_response.valid? }.not_to raise_error
      end

      it 'returns false' do
        expect(payment_gateway_response.valid?).to be false
      end
    end
  end

  describe '#success?' do
    context 'when the gateway indicates a' do
      context 'successful transation' do
        it 'returns true' do
          ['5', '51', '9', '91'].each do |code|
            query_string.sub!(/(?<=STATUS=)\w+/, code)

            expect(payment_gateway_response.success?).to be true
          end
        end
      end

      context 'failed transaction' do
        before { query_string.sub!(/(?<=STATUS=)\w+/, 'FAIL') }

        it 'returns false' do
          expect(payment_gateway_response.success?).to be false
        end
      end
    end
  end

  describe '#amount' do
    it 'returns the amount from the gateway response' do
      expect(payment_gateway_response.amount).to eq '250'
    end
  end

  describe '#reference' do
    it 'returns the transaction reference from the gateway response' do
      expect(payment_gateway_response.reference).to eq '34707458'
    end
  end

  describe '#status' do
    it 'returns the status code from the gateway response' do
      expect(payment_gateway_response.status).to eq '9'
    end
  end
end
