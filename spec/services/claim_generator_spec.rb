require "rails_helper"

describe ClaimGenerator, type: :service do
  let(:address) {
    object_double Address.new,
      building: '1 Towers',
      street: 'Marble Walk',
      locality: 'Smallville',
      county: 'Smallvilleshire',
      post_code: 'SW1 1WS',
      telephone_number: '020 1234 5678'
  }

  let(:claimant) {
    object_double Claimant.new,
      title: 'Mr',
      first_name: 'Bill',
      last_name: 'Jones',
      address: address,
      mobile_number: '020 1234 1234',
      email_address: 'claimant@example.com',
      fax_number: '020 1234 4321',
      contact_preference: 'post'
  }

  let(:respondent) {
    object_double Respondent.new,
      name: 'Harry Hill',
      address: address,
      work_address: address,
      acas_early_conciliation_certificate_number: 123123123123,
      no_acas_number_reason: 'acas_has_no_jurisdiction'
  }

  let(:representative) {
    object_double Representative.new,
      name: 'Rep. Barker',
      address: address,
      mobile_number: '020 1122 3344',
      email_address: 'rep@example.com'
  }

  let(:claim) {
    object_double Claim.new,
      id: 1,
      created_at: DateTime.new(2014, 1, 2, 3, 4, 5),
      submitted_at: DateTime.new(2014, 1, 2, 11, 40, 28),
      fee_group_reference: 123456789000,
      other_claim_details: '',
      claimant_count: 1,
      remission_claimant_count: 0,
      primary_claimant: claimant,
      primary_respondent: respondent,
      claimants: [claimant],
      respondents: [respondent],
      representative: representative,
      office: {code: 12}
  }

  subject { ClaimGenerator.new(claim) }
  describe '#to_xml' do
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
