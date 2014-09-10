require 'rails_helper'

RSpec.describe Address, :type => :model do
  it { is_expected.to belong_to :addressable }

  describe '#to_xml' do
    subject do
      Address.new(
        building: '1 Towers',
        street: 'Marble Walk',
        locality: 'Smallville',
        county: 'Smallvilleshire',
        post_code: 'SW1 1WS')
    end

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
