require 'rails_helper'

RSpec.describe Stats::ClaimStats, type: :model do

  let!(:completed_claim)      { create :claim, :submitted }
  let!(:old_completed_claim)  { create :claim, :submitted, created_at: 91.days.ago }
  let!(:started_claim)        { create :claim, :not_submitted }
  let!(:old_started_claim)    { create :claim, :not_submitted, created_at: 91.days.ago }
  let!(:not_started_claim)    { Claim.create }

  describe '.started_claims' do
    it 'returns claims started within the past 91 days' do
      results = described_class.started_claims
      expect(results.size).to eq 1

      query_result_record = results.first
      expect(query_result_record.reference).to eq started_claim.reference
    end
  end

  describe '.started_count' do
    it 'defers to .started_claims to return a count' do
      expect(described_class).to receive(:started_claims).and_call_original
      expect(described_class.started_count).to eq 1
    end
  end

  describe '.completed_claims' do
    it 'returns claims completed within the past 91 days' do
      results = described_class.completed_claims
      expect(results.size).to eq 1

      query_result_record = results.first
      expect(query_result_record.reference).to eq completed_claim.reference
    end
  end

  describe '.completed_count' do
    it 'defers to .completed_claims to return a count' do
      expect(described_class).to receive(:completed_claims).and_call_original
      expect(described_class.completed_count).to eq 1
    end
  end
end
