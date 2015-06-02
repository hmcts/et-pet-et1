require 'rails_helper'

RSpec.describe Stats::ClaimStats, type: :model do

  let!(:not_started_claim)    { Claim.create }

  describe 'query scopes' do
    describe '.started' do

      let!(:started_claim)        { create :claim, :not_submitted }
      let!(:old_started_claim)    { create :claim, :not_submitted, created_at: 91.days.ago }
      let!(:completed_claim)      { create :claim, :submitted }

      it 'returns claims started within the past 91 days' do
        results = described_class.started
        expect(results.size).to eq 1

        query_result_record = results.first
        expect(query_result_record.reference).to eq started_claim.reference
      end
    end

    describe '.started_count' do
      it 'defers to the started scope to return a count' do
        expect(described_class).to receive_message_chain('started.count') { 5 }
        expect(described_class.started_count).to eq 5
      end
    end

    describe '.completed' do

      let!(:completed_claim)      { create :claim, :submitted }
      let!(:old_completed_claim)  { create :claim, :submitted, created_at: 91.days.ago }
      let!(:started_claim)        { create :claim, :not_submitted }

      it 'returns claims completed within the past 91 days' do
        results = described_class.completed
        expect(results.size).to eq 1

        query_result_record = results.first
        expect(query_result_record.reference).to eq completed_claim.reference
      end
    end

    describe '.completed_count' do
      it 'defers to the completed scope to return a count' do
        expect(described_class).to receive_message_chain('completed.count') { 5 }
        expect(described_class.completed_count).to eq 5
      end
    end

    describe '.paid' do

      let!(:completed_paid_claim)      { create :claim, :submitted, payment: create(:payment) }
      let!(:completed_remission_claim) { create :claim, :submitted, payment: nil }
      let!(:started_claim)             { create :claim, :not_submitted }

      it 'returns claims that have been submitted with a payment' do
        results = described_class.paid
        expect(results.size).to eq 1

        query_result_record = results.first
        expect(query_result_record.reference).
          to eq completed_paid_claim.reference
      end
    end

    describe '.paid_count' do
      it 'defers to the paid scope to return a count' do
        expect(described_class).to receive_message_chain('paid.count') { 5 }
        expect(described_class.paid_count).to eq 5
      end
    end

    describe '.remission' do

      let!(:completed_paid_claim)      { create :claim, :submitted, payment: create(:payment) }
      let!(:completed_remission_claim) { create :claim, :submitted, payment: nil }
      let!(:started_claim)             { create :claim, :not_submitted }

      it 'returns claims that have been submitted without a payment(applied for remission)' do
        results = described_class.remission
        expect(results.size).to eq 1

        query_result_record = results.first
        expect(query_result_record.reference).
          to eq completed_remission_claim.reference
      end
    end

    describe '.remission_count' do
      it 'defers to the remission scope to return a count' do
        expect(described_class).to receive_message_chain('remission.count') { 5 }
        expect(described_class.remission_count).to eq 5
      end
    end

  end
end
