require 'rails_helper'

RSpec.describe Jadu::API::ParsedResponse do
  let(:response) do
    instance_double Net::HTTPResponse,
      body: '{"feeGroupReference":"991000185700","status":"ok"}'
  end

  describe '#ok?' do
    it 'is OK if the status was 200' do
      allow(response).to receive(:code) { '200' }
      expect(described_class.new(response)).to be_ok
    end

    it 'is not OK if the status was not 200' do
      allow(response).to receive(:code) { '400' }
      expect(described_class.new(response)).not_to be_ok
    end
  end

  it '#[]' do
    expect(described_class.new(response)['feeGroupReference']).
      to eql('991000185700')
  end

  it '#values_at' do
    expect(described_class.new(response).values_at('feeGroupReference', 'status')).
      to eq %w<991000185700 ok>
  end

  it '#to_h' do
    expected = { 'feeGroupReference' => '991000185700', 'status' => 'ok' }
    expect(described_class.new(response).to_h).to eql(expected)
  end
end
