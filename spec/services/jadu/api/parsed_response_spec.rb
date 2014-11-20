require 'rails_helper'

RSpec.describe Jadu::API::ParsedResponse do
  let(:response) { double(:response) }

  it 'is OK if the status was 200' do
    allow(response).to receive(:code) { '200' }
    expect(described_class.new(response)).to be_ok
  end

  it 'is not OK if the status was not 200' do
    allow(response).to receive(:code) { '400' }
    expect(described_class.new(response)).not_to be_ok
  end

  it 'exposes JSON fields via []' do
    json = '{"feeGroupReference":"991000185700","status":"ok"}'
    allow(response).to receive(:body) { json }
    expect(described_class.new(response)['feeGroupReference']).
      to eql('991000185700')
  end

  it 'exports a hash' do
    json = '{"feeGroupReference":"991000185700","status":"ok"}'
    allow(response).to receive(:body) { json }
    expected = { 'feeGroupReference' => '991000185700', 'status' => 'ok' }
    expect(described_class.new(response).to_hash).to eql(expected)
  end
end
