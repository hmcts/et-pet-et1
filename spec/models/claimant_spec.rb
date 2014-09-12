require 'rails_helper'

RSpec.describe Claimant, :type => :model do
  it { is_expected.to have_one :address }
  it_behaves_like "it has an address", :address

  describe '#address' do
    describe 'when the association is empty' do
      it 'prepopulates the association with a bare address' do
        expect(subject.address).to be_an Address
      end
    end
  end

  describe '#to_xml' do
    subject do
      described_class.new title: 'Mr',
        first_name: 'Bill',
        last_name: 'Jones',
        mobile_number: '020 1234 1234',
        email_address: 'claimant@example.com',
        fax_number: '020 1234 4321',
        contact_preference: 'post',
        address: Address.new(telephone_number: '020 1111 1111')
    end
    let(:claim) { object_double Claim.new, primary_claimant: subject }
    before { allow(subject).to receive(:claim).and_return claim }

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
