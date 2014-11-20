require 'rails_helper'

RSpec.describe Jadu::API::ETOffice do
  let(:uri) { URI.parse('https://example.com/api') }

  it 'constructs a request with URI, options, and a postcode field' do
    expect(Jadu::API::Request).to receive(:new).
      with(uri, [Multipart::StringParam.new('postcode', 'SW1A 1AA')], foo: 'bar')
    described_class.new(uri, 'SW1A 1AA', foo: 'bar')
  end

  it 'forwards :perform to the API request' do
    api_request = double(:api_request)
    allow(Jadu::API::Request).to receive(:new) { api_request }

    expect(api_request).to receive(:perform)
    described_class.new(uri, 'SW1A 1AA').perform
  end
end
