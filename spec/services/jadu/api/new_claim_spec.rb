require 'rails_helper'

RSpec.describe Jadu::API::NewClaim do
  let(:uri) { URI.parse('https://example.com/api') }
  let(:xml) { '<xml />' }

  it 'constructs a request with URI, fields, and options' do
    params = [
      Multipart::StringParam.new('new_claim', xml),
      Multipart::FileParam.new('example.pdf', 'example.pdf', 'AAA')
    ]

    expect(Jadu::API::Request).to receive(:new).with(uri, params, foo: 'bar')
    described_class.new(uri, xml, { 'example.pdf' => 'AAA' }, foo: 'bar')
  end

  it 'forwards :do to the API request' do
    api_request = double(:api_request)
    allow(Jadu::API::Request).to receive(:new) { api_request }

    expect(api_request).to receive(:do)
    described_class.new(uri, xml, {}).do
  end
end
