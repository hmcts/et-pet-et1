require "rails_helper"

describe ClaimGenerator, type: :service do
  let(:address) {
    Address.new \
      building: '1 Towers',
      street: 'Marble Walk',
      locality: 'Smallville',
      county: 'Smallvilleshire',
      post_code: 'SW1 1WS',
      telephone_number: '020 1234 5678'
  }

  let(:claimant) {
    Claimant.new \
      title: 'Mr',
      first_name: 'Bill',
      last_name: 'Jones',
      mobile_number: '020 1234 1234',
      email_address: 'claimant@example.com',
      fax_number: '020 1234 4321',
      contact_preference: 'post',
      primary_claimant: true
  }
  before { claimant.address = address }

  let(:respondent) {
    Respondent.new \
      name: 'Harry Hill',
      acas_early_conciliation_certificate_number: 123123123123,
      no_acas_number_reason: 'acas_has_no_jurisdiction',
      primary_respondent: true
  }
  before { respondent.addresses = [address, address] }

  let(:representative) {
    Representative.new \
      name: 'Rep. Barker',
      mobile_number: '020 1122 3344',
      email_address: 'rep@example.com'
  }
  before { representative.address = address }

  let(:claim) {
    Claim.new \
      id: 1,
      created_at: DateTime.new(2014, 1, 2, 3, 4, 5),
      submitted_at: DateTime.new(2014, 1, 2, 11, 40, 28),
      fee_group_reference: 123456789000,
      other_claim_details: '',
      claimants: [claimant],
      respondents: [respondent],
      representative: representative,
      payment: Payment.new(amount: 1, reference: 1234, created_at: DateTime.new(2014, 1, 2, 3, 5, 5)),
      office: Office.new(code: 12)
  }
  before { allow(claim).to receive(:claimant_count).and_return 1 }

  subject { ClaimGenerator.new(claim) }
  describe '#to_xml' do
    before { allow(Time.zone).to receive(:now).and_return DateTime.new(2014, 10, 11, 9, 10, 58, 0).in_time_zone }
    it 'Generates an XML document of the claim' do
      actual = Nokogiri::XML(subject.to_xml).to_s
      example = File.read(Rails.root.join('spec/support/example_claim.xml'))
      expect(actual).to eq(example)
    end

    it 'validates against the schema' do
      xsd = Nokogiri::XML::Schema(File.read(Rails.root.join('spec/support/ETFees.xsd')))
      doc = Nokogiri::XML(subject.to_xml)
      expect(xsd.validate(doc)).to eq([])
    end
  end
end
