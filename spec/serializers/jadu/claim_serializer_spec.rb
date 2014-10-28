require 'rails_helper'

RSpec.describe Jadu::ClaimSerializer, type: :serializer do
  let(:timestamp) { DateTime.new(2014, 10, 11, 9, 10, 58) }

  describe '#timestamp' do
    before do
      allow(subject).to receive(:timestamp).and_return(timestamp)
    end

    it 'returns the current time' do
      allow(Time).to receive_message_chain(:zone, :now) { timestmp }
      expect(subject.timestamp).to eq(timestamp)
    end
  end

  describe 'case_type' do
    context 'when single claimant' do
      before { allow(claim).to receive(:claimant_count).and_return(1) }
      it 'returns "Single"' do
        expect(subject.case_type(claim)).to eq('Single')
      end
    end

    context 'when multiple claimants' do
      before { allow(claim).to receive(:claimant_count).and_return(2) }
      it 'returns "Multiple"' do
        expect(subject.case_type(claim)).to eq('Multiple')
      end
    end
  end

  describe '#jurisdiction' do
    context 'when not other claim type' do
      before do
        allow(claim).to receive(:other_claim_details).and_return(nil)
      end

      it 'is "1"' do
       expect(subject.jurisdiction(claim)).to eq(1)
     end
    end

    context 'when other claim type' do
      before do
        allow(claim).to receive(:other_claim_details).and_return('other claim details')
      end

      it 'is "2"' do
        expect(subject.jurisdiction(claim)).to eq(2)
      end
    end
  end

  describe '#remission_indicated' do
    context 'when no remission claimants' do
      before do
        allow(claim).to receive(:remission_claimant_count).and_return(0)
      end

      it 'is "NotRequested"' do
        expect(subject.remission_indicated(claim)).to eq('NotRequested')
      end
    end

    context 'when remission claimants' do
      before do
        allow(claim).to receive(:remission_claimant_count).and_return(1)
      end

      it 'is "Indicated"' do
        expect(subject.remission_indicated(claim)).to eq('Indicated')
      end
    end
  end

  describe '#to_xml' do
    let(:timestamp) { DateTime.new(2014, 10, 11, 9, 10, 58) }
    let(:claim) do
      Claim.new(
        id: 1,
        created_at: DateTime.new(2014, 1, 2, 3, 4, 5),
        submitted_at: DateTime.new(2014, 1, 2, 11, 40, 28),
        fee_group_reference: 123456789000,
        other_claim_details: '',
        office: Office.new(code: 12)
      )
    end
    subject { described_class.new claim }

    before do
      allow(subject).to receive(:claimant_count).and_return 1
      allow(subject).to receive(:timestamp).and_return(timestamp)
    end

    it 'outputs XML according to Jadu spec' do
      expect(subject.to_xml(indent: 2)).to eq <<-END.gsub(/^ {6}/, '')
      <?xml version="1.0" encoding="UTF-8"?>
      <ETFeesEntry xmlns="http://www.justice.gov.uk/ETFEES" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="ETFees_v0.09.xsd">
        <DocumentID>
          <DocumentName>ETFeesEntry</DocumentName>
          <UniqueID>20140102030405</UniqueID>
          <DocumentType>ETFeesEntry</DocumentType>
          <TimeStamp>2014-10-11T09:10:58+00:00</TimeStamp>
          <Version>1</Version>
        </DocumentID>
        <FeeGroupReference>123456789000</FeeGroupReference>
        <SubmissionURN>1</SubmissionURN>
        <CurrentQuantityOfClaimants>1</CurrentQuantityOfClaimants>
        <SubmissionChannel>Web</SubmissionChannel>
        <CaseType>Single</CaseType>
        <Jurisdiction>1</Jurisdiction>
        <OfficeCode>12</OfficeCode>
        <DateOfReceiptET>2014-01-02 11:40:28 UTC</DateOfReceiptET>
        <RemissionIndicated>NotRequested</RemissionIndicated>
        <Administrator xsi:nil="true"/>
      </ETFeesEntry>
      END
    end
  end

end
