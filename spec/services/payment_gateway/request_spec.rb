require 'rails_helper'

RSpec.describe PaymentGateway::Request, type: :service do
  let(:request) { double 'request', url: 'https://example.org/apply/pay' }
  subject { described_class.new request, reference: 'lol', amount: 250 }

  describe '#request_url' do
    context 'in test' do
      it 'returns the test request url' do
        expect(subject.request_url).
          to eq "https://mdepayments.epdq.co.uk/ncol/test/orderstandard.asp"
      end
    end

    context 'in production' do
      before { allow(EPDQ).to receive(:test_mode).and_return false }

      it 'returns the production request url' do
        expect(subject.request_url).
          to eq "https://payments.epdq.co.uk/ncol/prod/orderstandard.asp"
      end
    end
  end

  describe '#form_attributes' do
    before { allow(EPDQ).to receive(:sha_in).and_return 'lelelelelel' }

    let(:attributes) do
      {
         "SHASIGN" => "1CC44DE8F0565A0CE267A8EBBDF8122AA935CE5143F3E0976CC5B8490A119FF3",
        "CURRENCY" => "GBP",
        "LANGUAGE" => "en_US",
       "ACCEPTURL" => "https://example.org/apply/pay/success",
      "DECLINEURL" => "https://example.org/apply/pay/decline",
          "AMOUNT" => "250",
         "ORDERID" => "lol",
           "PSPID" => "ministry2",
              "TP" => "https://example.org/apply/barclaycard-payment-template"
      }
    end

    it 'returns an hash of form attributes needed to perform the request' do
      subject.form_attributes.each do |key, value|
        expect(attributes[key]).to eq value
      end
    end
  end
end
