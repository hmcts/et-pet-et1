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
         "SHASIGN" => "0056678DA525BD224C54D539E0235E22340E3540BB1E7392AB6F278CBE530700",
        "CURRENCY" => "GBP",
        "LANGUAGE" => "en_US",
       "ACCEPTURL" => "https://example.org/apply/pay/success",
      "DECLINEURL" => "https://example.org/apply/pay/decline",
    "EXCEPTIONURL" => "https://example.org/apply/pay/exception",
       "CANCELURL" => "https://example.org/apply/pay/cancel",
          "AMOUNT" => "250",
         "ORDERID" => "lol",
           "PSPID" => "ministry2"
      }
    end

    it 'returns an hash of form attributes needed to perform the request' do
      subject.form_attributes.each do |key, value|
        expect(attributes[key]).to eq value
      end
    end
  end
end
