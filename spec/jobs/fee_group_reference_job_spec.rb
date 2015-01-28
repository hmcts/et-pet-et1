require 'rails_helper'

describe FeeGroupReferenceJob, type: :job do
  let(:claim) { create :claim }
  let(:postcode) { 'SW2 2WS' }
  let(:fee_group_reference) { double reference: 1234567890, office_code: 11, office_name: 'Puddletown', office_address: '1 Some road, Puddletown', office_telephone: '020 1234 5678' }

  before do
    allow(FeeGroupReference).to receive(:create).with(postcode: postcode).and_return fee_group_reference
    allow(claim).to receive(:create_event).with 'fee_group_reference_request'
  end

  describe '#perform' do
    it 'saves fee_group_reference and office details' do
      expect(claim).to receive(:update!).with(fee_group_reference: 1234567890)
      expect(claim).to receive(:create_office!).with(code: 11, name: 'Puddletown', address: '1 Some road, Puddletown', telephone: '020 1234 5678')

      subject.perform(claim, postcode)
    end

    it 'creates a log event' do
      allow(claim).to receive(:update!)
      expect(claim).to receive(:create_event).with 'fee_group_reference_request'
      subject.perform(claim, postcode)
    end
  end
end
