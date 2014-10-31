require 'rails_helper'

RSpec.describe Jadu::ClaimSerializer, type: :serializer do
  let(:claim) do
    Claim.new(
      id: 1,
      created_at: DateTime.new(2014, 1, 2, 3, 4, 5),
      submitted_at: DateTime.new(2014, 1, 2, 11, 40, 28),
      fee_group_reference: 123456789000,
      other_claim_details: '',
      office: Office.new(code: 12),
      payment: Payment.new
    )
  end

  subject { described_class.new(claim) }
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
      before do
        allow(claim).to receive(:other_claim_details).and_return(nil)
      end

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
      before do
        allow(claim).to receive(:remission_claimant_count).and_return(0)
      end

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

  describe '#to_xml' do
    let(:timestamp) { DateTime.new(2014, 10, 11, 9, 10, 58) }
    before do
      allow(claim).to receive(:claimant_count).and_return 1
      allow(claim).to receive(:remission_claimant_count).and_return 0
      allow(subject).to receive(:timestamp).and_return timestamp
    end

    it 'outputs XML according to Jadu spec' do
      expect(subject.to_xml(indent: 2)).to eq <<-END.gsub(/^ {6}/, '')
      <?xml version="1.0" encoding="UTF-8"?>
      <ETFeesEntry xmlns="http://www.justice.gov.uk/ETFEES" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="ETFees.xsd">
        <DocumentId>
          <DocumentName>ETFeesEntry</DocumentName>
          <UniqueId>20140102030405</UniqueId>
          <DocumentType>ETFeesEntry</DocumentType>
          <TimeStamp>2014-10-11T09:10:58+00:00</TimeStamp>
          <Version>1</Version>
        </DocumentId>
        <FeeGroupReference>123456789000</FeeGroupReference>
        <SubmissionUrn>1</SubmissionUrn>
        <CurrentQuantityOfClaimants>1</CurrentQuantityOfClaimants>
        <SubmissionChannel>Web</SubmissionChannel>
        <CaseType>Single</CaseType>
        <Jurisdiction>1</Jurisdiction>
        <OfficeCode>12</OfficeCode>
        <DateOfReceiptEt>2014-01-02T11:40:28Z</DateOfReceiptEt>
        <RemissionIndicated>NotRequested</RemissionIndicated>
        <Administrator xsi:nil="true"/>
        <Payment>
          <Fee>
            <Amount/>
            <PRN/>
            <Date/>
          </Fee>
        </Payment>
        <UserCharacteristics>
          <DeclinedToAnswer>true</DeclinedToAnswer>
          <ClaimType/>
          <Sex/>
          <GenderIdentityBirth/>
          <GenderIdentityNow/>
          <SexualOrientation/>
          <MaritalStatus/>
          <AgeGroup/>
          <CaringResponsibilities/>
          <Religion/>
          <EthnicityPartA/>
          <EthnicityPartB/>
          <Disability/>
          <Pregnancy/>
        </UserCharacteristics>
        <Files/>
      </ETFeesEntry>
      END
    end
  end

end
