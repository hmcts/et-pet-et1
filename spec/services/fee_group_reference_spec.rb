require "rails_helper"

RSpec.describe FeeGroupReference, type: :service do
  describe '.create' do
    let(:request) do
      stub_request(:post, 'https://etapi.employmenttribunals.service.gov.uk/1/new_claim').
        with(postcode: 'SW1A 1AA').to_return body: json,
          headers: { 'Content-Type' => 'application/json' }
    end

    let(:json) do
      '{ "fgr":511234567800,"ETOfficeCode":22,"ETOfficeName":"Birmingham",' +
      '"ETOfficeAddress":"Centre City Tower, 5­7 Hill Street, Birmingham B5 4UU",' +
      '"ETOfficeTelephone":"0121 600 7780"}'
    end

    before { request }

    describe 'making the API request' do
      it 'calls the FGR service' do
        FeeGroupReference.create postcode: 'SW1 1AA'

        expect(request).to have_been_made
      end
    end

    context 'when the API request is successful' do
      let(:fgr) { FeeGroupReference.create postcode: 'SW1 1AA' }

      it 'returns an instance exposing the fee group reference' do
        expect(fgr.reference).to eq(511234567800)
      end
    end

    context 'when the API request is unsuccessful' do
      before { request.response.status = 500 }

      let(:json) do
        '{"status":"error","errorCode":1001,' +
        '"errorDescription": "Unable to connect to ETFees database"}'
      end

      it 'makes an API request' do
        expect { FeeGroupReference.create postcode: 'SW1 1AA' }.
          to raise_error RuntimeError
      end
    end
  end
end
