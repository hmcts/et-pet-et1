require 'rails_helper'

RSpec.describe Stats::ClaimStats, type: :model do

  describe 'scopes' do
    let!(:started_claim)                    { create :claim, :not_submitted }
    let!(:old_started_claim)                { create :claim, :not_submitted, created_at: 91.days.ago }
    let!(:old_out_of_range_started_claim)   { create :claim, :not_submitted, created_at: 92.days.ago }
    let!(:completed_claim)                  { create :claim, :submitted }
    let!(:old_completed_claim)              { create :claim, :submitted, created_at: 91.days.ago }
    let!(:old_out_of_range_completed_claim) { create :claim, :submitted, created_at: 92.days.ago }
    let!(:not_started_claim)                { Claim.create }

    describe '.started_within_max_submission_timeframe' do
      it 'returns claims started within the past 91 days' do
        results = described_class.started_within_max_submission_timeframe
        expect(results.size).to eq 2

        query_result_record = results.first
        expect(query_result_record.reference).to eq started_claim.reference
      end
    end

    describe '.completed_within_max_submission_timeframe' do
      it 'returns claims completed within the past 91 days' do
        results = described_class.completed_within_max_submission_timeframe
        expect(results.size).to eq 2

        query_result_record = results.first
        expect(query_result_record.reference).to eq completed_claim.reference
      end
    end
  end

  describe '.completed_count' do
    it 'utilises the completed scope to return a count' do
      expect(described_class).
        to receive_message_chain('completed_within_max_submission_timeframe.count') { 5 }
      expect(described_class.completed_count).to eq 5
    end
  end

  describe '.started_count' do
    it 'utilises the started scope to return a count' do
      expect(described_class).
        to receive_message_chain('started_within_max_submission_timeframe.count') { 5 }
      expect(described_class.started_count).to eq 5
    end
  end
end
