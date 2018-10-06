require 'rails_helper'

describe FeeGroupReferenceJob, type: :job do
  let(:claim) { create :claim }
  let(:postcode) { 'SW2 2WS' }
  let(:fee_group_reference) { { reference: 1234567890, office: { code: 11, name: 'Puddletown', address: '1 Some road, Puddletown', telephone: '020 1234 5678' }} }
  let(:fee_group_reference_job) { FeeGroupReferenceJob.new }

  before do
    allow(EtApi).to receive(:create_reference).with(postcode: postcode).and_return fee_group_reference
    allow(claim).to receive(:create_event).with 'fee_group_reference_request'
  end

  describe '#perform' do
    it 'updates fee_group_reference' do
      expect(claim).to receive(:update!).with(fee_group_reference: 1234567890)

      fee_group_reference_job.perform(claim, postcode)
    end

    it 'saves office details' do
      expect(claim).to receive(:create_office!).with(code: 11, name: 'Puddletown', address: '1 Some road, Puddletown', telephone: '020 1234 5678')

      fee_group_reference_job.perform(claim, postcode)
    end

    it 'creates a log event' do
      allow(claim).to receive(:update!)
      expect(claim).to receive(:create_event).with 'fee_group_reference_request'
      fee_group_reference_job.perform(claim, postcode)
    end
  end
end
