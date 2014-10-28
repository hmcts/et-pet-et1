require 'rails_helper'

RSpec.describe Jadu::RepresentativeSerializer, type: :serializer do
  describe '#to_xml' do
    let(:representative) do
      Representative.new(
        name: 'Rep. Barker',
        mobile_number: '020 1122 3344',
        email_address: 'rep@example.com',
        address: Address.new(telephone_number: '020 1111 1111')
      )
    end
    subject { described_class.new(representative) }

    it 'outputs XML according to Jadu spec' do
      expect(subject.to_xml(indent: 2)).to eq <<-END.gsub(/^ {6}/, '')
      <Representatives>
        <Representative>
          <Name>Rep. Barker</Name>
          <OfficeNumber>020 1111 1111</OfficeNumber>
          <AltPhoneNumber>020 1122 3344</AltPhoneNumber>
          <Email>rep@example.com</Email>
          <ClaimantOrRespondent>C</ClaimantOrRespondent>
        </Representative>
      </Representatives>
      END
    end
  end
end
