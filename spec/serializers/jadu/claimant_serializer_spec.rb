require 'rails_helper'

RSpec.describe Jadu::ClaimantSerializer, type: :serializer do
  describe '#to_xml' do
    let(:claimant) do
      Claimant.new title: 'Mr',
        primary_claimant: true,
        first_name: 'Bill',
        last_name: 'Jones',
        mobile_number: '020 1234 1234',
        email_address: 'claimant@example.com',
        fax_number: '020 1234 4321',
        contact_preference: 'post',
        address: Address.new(telephone_number: '020 1111 1111')
    end
    subject { described_class.new claimant }

    it 'outputs XML according to Jadu spec' do
      expect(subject.to_xml(indent: 2)).to eq <<-END.gsub(/^ {8}/, '')
        <Claimant>
          <GroupContact>true</GroupContact>
          <Title>Mr</Title>
          <Forename>Bill</Forename>
          <Surname>Jones</Surname>
          <OfficeNumber>020 1111 1111</OfficeNumber>
          <AltPhoneNumber>020 1234 1234</AltPhoneNumber>
          <Email>claimant@example.com</Email>
          <Fax>020 1234 4321</Fax>
          <PreferredContactMethod>Post</PreferredContactMethod>
        </Claimant>
      END
    end
  end
end
