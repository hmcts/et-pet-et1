require 'rails_helper'

RSpec.describe FeatureFlagValue, type: :model do
  describe '.active' do
    it 'includes open and current date windows, including their boundaries' do
      freeze_time
      unbounded = described_class.create!(flag_key: 'test_feature', value: true)
      started = described_class.create!(flag_key: 'test_feature', valid_from: 1.day.ago)
      ending = described_class.create!(flag_key: 'test_feature', valid_to: 1.day.from_now)
      boundary = described_class.create!(flag_key: 'test_feature', valid_from: Time.current, valid_to: Time.current)
      described_class.create!(flag_key: 'test_feature', valid_from: 1.day.from_now)
      described_class.create!(flag_key: 'test_feature', valid_to: 1.day.ago)

      expect(described_class.active).to contain_exactly(unbounded, started, ending, boundary)
    end
  end

  describe '.newest_first' do
    it 'orders values by creation time, newest first' do
      older = described_class.create!(flag_key: 'test_feature', created_at: 2.days.ago)
      newer = described_class.create!(flag_key: 'test_feature', created_at: 1.day.ago)

      expect(described_class.newest_first).to eq([newer, older])
    end
  end

  describe '.current' do
    it 'returns the newest active value for the requested flag' do
      described_class.create!(flag_key: 'test_feature', created_at: 2.days.ago)
      current = described_class.create!(flag_key: 'test_feature', created_at: 1.day.ago)
      described_class.create!(flag_key: 'test_feature', valid_from: 1.day.from_now)
      described_class.create!(flag_key: 'test_feature', valid_to: 1.day.ago)
      described_class.create!(flag_key: 'other_feature')

      expect(described_class.where(flag_key: 'test_feature').current).to eq(current)
    end

    it 'returns nil when there are no active values' do
      described_class.create!(flag_key: 'test_feature', valid_to: 1.day.ago)

      expect(described_class.current).to be_nil
    end
  end
end
