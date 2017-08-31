require 'rails_helper'

RSpec.describe Jadu::API do
  let(:jadu_api) { described_class.new(base_url, ssl_version: :TLSv1) }
  let(:base_url) { 'https://example.com/api/1/' }
  let(:response) { instance_double('HTTParty::Response') }
  let(:parsed_response) { instance_double('Jadu::API::ParsedResponse') }

  context 'ETOffice' do
    let(:eto) { instance_double('ETOffice') }
    let(:uri) { URI.parse('https://example.com/api/1/fgr-et-office') }
    let(:postcode) { 'SW1A 1AA' }

    it 'constructs an ET Office request' do
      expect(Jadu::API::ETOffice).to receive(:new).
        with(uri, postcode, ssl_version: :TLSv1) { eto }
      allow(eto).to receive(:perform) { response }
      allow(Jadu::API::ParsedResponse).to receive(:new)

      jadu_api.fgr_et_office(postcode)
    end

    it 'sends an ET Office request' do
      allow(Jadu::API::ETOffice).to receive(:new).
        with(uri, postcode, ssl_version: :TLSv1) { eto }
      expect(eto).to receive(:perform) { response }
      allow(Jadu::API::ParsedResponse).to receive(:new)

      jadu_api.fgr_et_office(postcode)
    end

    it 'parses an ETOffice' do
      allow(Jadu::API::ETOffice).to receive(:new).
        with(uri, postcode, ssl_version: :TLSv1) { eto }
      allow(eto).to receive(:perform) { response }
      expect(Jadu::API::ParsedResponse).to receive(:new).
        with(response) { parsed_response }

      jadu_api.fgr_et_office(postcode)
    end

    it 'returned parsed ETOffice response' do
      allow(Jadu::API::ETOffice).to receive(:new).
        with(uri, postcode, ssl_version: :TLSv1) { eto }
      allow(eto).to receive(:perform) { response }
      allow(Jadu::API::ParsedResponse).to receive(:new).
        with(response) { parsed_response }

      expect(jadu_api.fgr_et_office(postcode)).to eql(parsed_response)
    end
  end

  context 'New Claim' do
    let(:claim) { instance_double('NewClaim') }
    let(:uri) { URI.parse('https://example.com/api/1/new-claim') }
    let(:xml) { '<xml />' }

    it 'constructs and sends a New Claim request and parses the response' do
      allow(claim).to receive(:perform)
      allow(Jadu::API::ParsedResponse).to receive(:new)

      expect(Jadu::API::NewClaim).to receive(:new).
        with(uri, xml, { 'example.pdf' => 'PDF' }, ssl_version: :TLSv1) { claim }

      jadu_api.new_claim(xml, 'example.pdf' => 'PDF')
    end

    it 'constructs New Claim' do
      allow(Jadu::API::NewClaim).to receive(:new) { claim }
      allow(Jadu::API::ParsedResponse).to receive(:new)
      expect(claim).to receive(:perform)

      jadu_api.new_claim(xml, 'example.pdf' => 'PDF')
    end

    it 'sends a New Claim request' do
      allow(Jadu::API::NewClaim).to receive(:new) { claim }
      allow(claim).to receive(:perform) { response }
      expect(Jadu::API::ParsedResponse).to receive(:new).with(response)

      jadu_api.new_claim(xml, 'example.pdf' => 'PDF')
    end

    it 'parses the response' do
      allow(Jadu::API::NewClaim).to receive(:new) { claim }
      allow(claim).to receive(:perform) { response }
      allow(Jadu::API::ParsedResponse).to receive(:new).
        with(response) { parsed_response }

      expect(jadu_api.new_claim(xml, 'example.pdf' => 'PDF')).
        to eql(parsed_response)
    end
  end
end
