require 'rails_helper'

RSpec.describe Stats::ClaimStats, type: :model do

  describe 'scopes' do
    before do
      travel_to(current_time)
      started_claim
      old_started_claim
      old_out_of_range_started_claim
      completed_claim
      old_completed_claim
      old_out_of_range_completed_claim
      not_started_claim
    end

    after { travel_back }

    let(:current_time)                     { Time.zone.parse("2010-01-27 13:56:25") }
    let(:started_claim)                    { create :claim, :not_submitted }
    let(:old_started_claim)                { create :claim, :not_submitted, created_at: 91.days.ago }
    let(:old_out_of_range_started_claim)   { create :claim, :not_submitted, created_at: 92.days.ago }
    let(:completed_claim)                  { create :claim, :submitted }
    let(:old_completed_claim)              { create :claim, :submitted, created_at: 91.days.ago }
    let(:old_out_of_range_completed_claim) { create :claim, :submitted, created_at: 92.days.ago }
    let(:not_started_claim)                { Claim.create }

    describe '.started_within_max_submission_timeframe' do
      let(:results) { described_class.started_within_max_submission_timeframe }

      it 'returns claims started within the past 91 days' do
        expect(results.reload.size).to eq 2
      end

      it 'first record is the latest one' do
        query_result_record = results.first
        expect(query_result_record.reference).to eq started_claim.reference
      end
    end

    describe '.completed_within_max_submission_timeframe' do
      let(:results) { described_class.completed_within_max_submission_timeframe }

      it "has 7 claims" do
        expect(Claim.count).to be(7)
      end

      it 'returns claims completed within the past 91 days' do
        expect(results.size).to eq 2
      end

      it 'first record is the latest one' do
        query_result_record = results.first
        expect(query_result_record.reference).to eq completed_claim.reference
      end
    end
  end

  describe '.completed_count' do
    it 'utilises the completed scope to return a count' do
      allow(described_class).to receive(:completed_within_max_submission_timeframe).and_return [3, 4, 5]
      expect(described_class.completed_count).to eq 3
    end
  end

  describe '.started_count' do
    it 'utilises the started scope to return a count' do
      allow(described_class).to receive(:started_within_max_submission_timeframe).and_return [3, 4, 5]
      expect(described_class.started_count).to be 3
    end
  end
end
