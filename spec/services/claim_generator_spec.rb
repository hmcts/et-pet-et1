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
      office: double(Office, code: 12)
  }

  subject { ClaimGenerator.new(claim) }
  let(:timestamp) { DateTime.new(2014, 10, 11, 9, 10, 58) }

  before do
    allow(subject).to receive(:timestamp).and_return(timestamp)
  end

  describe '#to_xml' do
    it 'Generates an XML document of the claim' do
      actual = Nokogiri::XML(subject.to_xml).to_s
      example = File.read(Rails.root.join('spec/support/example_claim.xml'))
      expect(actual).to eq(example)
    end

    it 'validates against the schema' do
      xsd = Nokogiri::XML::Schema(File.read(Rails.root.join('spec/support/ETFees_v0.09.xsd')))
      doc = Nokogiri::XML(subject.to_xml)
      expect(xsd.validate(doc)).to eq([])
    end
  end

  describe '#timestamp' do
    it 'returns the current time' do
      allow(Time).to receive_message_chain(:zone, :now) { timestmp }
      expect(subject.timestamp).to eq(timestamp)
    end
  end

  describe 'case_type' do
    context 'when single claimant' do
      it 'returns "Single"' do
        expect(subject.case_type).to eq('Single')
      end
    end

    context 'when multiple claimants' do
      before { allow(claim).to receive(:claimant_count).and_return(2) }
      it 'returns "Multiple"' do
        expect(subject.case_type).to eq('Multiple')
      end
    end
  end

  describe '#jurisdiction' do
    context 'when not other claim type' do
      it 'is "1"' do
       expect(subject.jurisdiction).to eq(1)
     end
    end

    context 'when other claim type' do
      before do
        allow(claim).to receive(:other_claim_details).and_return('other claim details')
      end

      it 'is "2"' do
        expect(subject.jurisdiction).to eq(2)
      end
    end
  end

  describe '#remission_indicated' do
    context 'when no remission claimants' do
      it 'is "NotRequested"' do
        expect(subject.remission_indicated).to eq('NotRequested')
      end
    end

    context 'when remission claimants' do
      before do
        allow(claim).to receive(:remission_claimant_count).and_return(1)
      end

      it 'is "Indicated"' do
        expect(subject.remission_indicated).to eq('Indicated')
      end
    end
  end

  describe '#exemption_code' do
    it 'maps reason to Jadu exemption code' do
      expect(subject.exemption_code('claim_against_security_or_intelligence_services')).to eq('claim_targets')
    end
  end
end
