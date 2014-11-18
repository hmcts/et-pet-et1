require 'rails_helper'

RSpec.describe Jadu::API do
  subject { described_class.new(base_url, ssl_version: :TLSv1) }
  let(:base_url) { 'https://example.com/api/1/' }

  it 'constructs and sends an ET Office request and parses the response' do
    eto = double(:et_office)
    uri = URI.parse('https://example.com/api/1/fgr-et-office')
    postcode = 'SW1A 1AA'
    response = double(:response)
    parsed_response = double(:parsed_response)

    expect(Jadu::API::ETOffice).to receive(:new).
      with(uri, postcode, ssl_version: :TLSv1) { eto }
    expect(eto).to receive(:do) { response }
    expect(Jadu::API::ParsedResponse).to receive(:new).
      with(response) { parsed_response }

    expect(subject.fgr_et_office(postcode)).to eql(parsed_response)
  end

  it 'constructs and sends a New Claim request and parses the response' do
    claim = double(:new_claim)
    uri = URI.parse('https://example.com/api/1/new-claim')
    xml = '<xml />'
    response = double(:response)
    parsed_response = double(:parsed_response)

    expect(Jadu::API::NewClaim).to receive(:new).
      with(uri, xml, { 'example.pdf' => 'PDF' }, ssl_version: :TLSv1) { claim }
    expect(claim).to receive(:do) { response }
    expect(Jadu::API::ParsedResponse).to receive(:new).
      with(response) { parsed_response }

    expect(subject.new_claim(xml, 'example.pdf' => 'PDF')).
      to eql(parsed_response)
  end
end
