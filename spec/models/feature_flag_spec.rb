require 'rails_helper'

RSpec.describe FeatureFlag, type: :model do
  before { Current.reset }
  after { Current.reset }

  describe '.value_for' do
    let(:key) { 'test_feature' }

    it 'returns a cached false value without looking up records' do
      Current.feature_flag_values[key] = false

      expect(FeatureFlagValue).not_to receive(:where)
      expect(described_class).not_to receive(:where)
      expect(described_class.value_for(key)).to be(false)
    end

    it 'returns and caches the current override instead of the default' do
      described_class.create!(key: key, default_value: true)
      FeatureFlagValue.create!(flag_key: key, value: false)

      expect(described_class.value_for(key)).to be(false)
      expect(Current.feature_flag_values).to include(key => false)
    end

    it 'returns and caches the default when there is no current override' do
      described_class.create!(key: key, default_value: true)
      FeatureFlagValue.create!(flag_key: key, value: false, valid_to: 1.day.ago)

      expect(described_class.value_for(key)).to be(true)
      expect(Current.feature_flag_values).to include(key => true)
    end

    it 'returns and caches false for an unknown flag' do
      expect(described_class.value_for(key)).to be(false)
      expect(Current.feature_flag_values).to include(key => false)
    end
  end

  describe '#values' do
    it 'finds values by key and destroys them with the flag' do
      flag = described_class.create!(key: 'test_feature')
      value = FeatureFlagValue.create!(flag_key: flag.key, value: true)
      other_value = FeatureFlagValue.create!(flag_key: 'other_feature', value: false)

      expect(flag.values).to contain_exactly(value)

      flag.destroy!

      expect(FeatureFlagValue.exists?(value.id)).to be(false)
      expect(FeatureFlagValue.exists?(other_value.id)).to be(true)
    end
  end
end
