require 'rails_helper'

RSpec.describe Jadu::AddressSerializer, type: :serializer do
  describe '#address_number' do
    it 'returns number' do
      actual = subject.address_number('123 Some Road')
      expect(actual).to eq(123)
    end

    it 'return nil when no number' do
      actual = subject.address_number('Some Road')
      expect(actual).to be_nil
    end
  end

  describe "#address_name" do
    it 'returns name without spaces' do
      actual = subject.address_name('123 Some Road')
      expect(actual).to eq('Some Road')
    end
  end
  
  describe '#to_xml' do
    let(:address) do
      Address.new(
        building: '1 Towers',
        street: 'Marble Walk',
        locality: 'Smallville',
        county: 'Smallvilleshire',
        post_code: 'SW1 1WS')
    end
    subject { described_class.new(address) }

    it 'outputs XML according to Jadu spec' do
      expect(subject.to_xml(indent: 2)).to eq <<-END.gsub(/^ {8}/, '')
        <Address>
          <Number>1</Number>
          <Name>Towers</Name>
          <Street>Marble Walk</Street>
          <Town>Smallville</Town>
          <County>Smallvilleshire</County>
          <Postcode>SW1 1WS</Postcode>
        </Address>
      END
    end
  end
end
