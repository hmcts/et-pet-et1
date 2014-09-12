require 'rails_helper'

RSpec.describe Representative, :type => :model do
  it { is_expected.to have_one :address }
  it { is_expected.to belong_to :claim }

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
      described_class.new(
        name: 'Rep. Barker',
        mobile_number: '020 1122 3344',
        email_address: 'rep@example.com',
        address: Address.new(telephone_number: '020 1111 1111')
      )
    end
    
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
