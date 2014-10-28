require 'rails_helper'

RSpec.describe Jadu::RespondentSerializer, type: :serializer do
  describe '#exemption_code' do
    it 'maps reason to Jadu exemption code' do
      expect(subject.exemption_code('claim_against_security_or_intelligence_services')).to eq('claim_targets')
    end
  end

  describe '#split_first_line' do
    it 'splits into number and name' do
      actual = subject.building_split('123 Some Road')
      expect(actual).to eq(['123', ' Some Road'])
    end

    it 'returns nil when no number' do
      actual = subject.building_split('Some Road')
      expect(actual).to eq(['', 'Some Road'])
    end

    it 'takes only first four digits' do
      actual = subject.building_split('12345 Some Road')
      expect(actual).to eq(['1234', '5 Some Road'])
    end

    it 'only removes digits from start of address' do
      actual = subject.building_split('123 Some 3rd Road')
      expect(actual).to eq(['123', ' Some 3rd Road'])
    end
  end

  describe '#to_xml' do
    let(:respondent) do
      Respondent.new(
        primary_respondent: true,
        name: 'Harry Hill',
        addresses: [
          Address.new(telephone_number: '020 1111 1111'),
          Address.new(telephone_number: '020 1111 2222')
        ],
        acas_early_conciliation_certificate_number: 123123123123,
        no_acas_number_reason: 'acas_has_no_jurisdiction'
      )
    end

    subject { described_class.new(respondent) }

    it 'outputs XML according to Jadu spec' do
      expect(subject.to_xml(indent: 2)).to eq <<-END.gsub(/^ {6}/, '')
      <Respondent>
        <GroupContact>true</GroupContact>
        <Name>Harry Hill</Name>
        <OfficeNumber>020 1111 1111</OfficeNumber>
        <PhoneNumber>020 1111 2222</PhoneNumber>
        <Acas>
          <Number>123123123123</Number>
          <ExemptionCode>outside_acas</ExemptionCode>
        </Acas>
      </Respondent>
      END
    end
  end
end
