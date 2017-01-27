require 'rails_helper'

RSpec.describe Stats::ClaimStats, type: :model do

  describe 'scopes' do
    # before { Timecop.freeze(current_time) }
    # after { Timecop.return }

    subject { described_class }

    let!(:current_time)                     { Time.parse("2017-01-27 13:56:25") }
    let!(:started_claim)                    { create :claim, :not_submitted }
    let!(:old_started_claim)                { create :claim, :not_submitted, created_at: 91.days.ago }
    let!(:old_out_of_range_started_claim)   { create :claim, :not_submitted, created_at: 92.days.ago }
    let!(:completed_claim)                  { create :claim, :submitted }
    let!(:old_completed_claim)              { create :claim, :submitted, created_at: 91.days.ago }
    let!(:old_out_of_range_completed_claim) { create :claim, :submitted, created_at: 92.days.ago }
    let!(:not_started_claim)                { Claim.create }

    describe '.started_within_max_submission_timeframe' do
      it 'returns claims started within the past 91 days' do
        results = subject.started_within_max_submission_timeframe
        # puts Time.now
        if results.reload.size < 2
          puts subject.all.map(&:created_at)
          puts "---"
          puts results.map(&:created_at)
        end
        expect(results.reload.size).to eq 2

        query_result_record = results.first
        expect(query_result_record.reference).to eq started_claim.reference
      end
    end

    describe '.completed_within_max_submission_timeframe' do
      it 'returns claims completed within the past 91 days' do
        expect(Claim.count).to eql(7)
        results = subject.completed_within_max_submission_timeframe
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

  describe 'timecop test' do
    it "time local" do
      Timecop.freeze( Time.local(1990, 1, 14, 10, 30)) do
        expect(Time.now.to_s(:db)).to eql('1990-01-14 10:30:00')
      end
    end

    it "time parse" do
      Timecop.freeze(Time.parse("1995-01-27 13:56:25")) do
        expect(Time.now.to_s(:db)).to eql('1995-01-27 13:56:25')
      end
    end

    it "time local" do
      t = Time.local(2008, 9, 1, 10, 5, 0)
      Timecop.travel(t)
      sleep 3
      expect(Time.now.to_s(:db)).to eql('2008-09-01 10:05:03')
    end
  end
end
