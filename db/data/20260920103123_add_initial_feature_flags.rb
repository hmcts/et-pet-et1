# frozen_string_literal: true

class AddInitialFeatureFlags < ActiveRecord::Migration[8.1]
  class FeatureFlag < ActiveRecord::Base
    self.table_name = :feature_flags
    has_many :values, class_name: 'AddInitialFeatureFlags::FeatureFlagValue', primary_key: 'key', foreign_key: 'flag_key', dependent: :destroy
  end

  class FeatureFlagValue < ActiveRecord::Base
    self.table_name = :feature_flag_values
  end

  def up
    return if FeatureFlag.exists?(key: 'era_oct_26')

    feature_flag = FeatureFlag.create(name: "ERA Oct 26", default_value: false, key: 'era_oct_26')
    feature_flag.values.create(valid_from: nil, valid_to: Time.zone.parse("30 September 2026 23:59:59"), value: false)
    feature_flag.values.create(valid_from: Time.zone.parse('1 October 2026 00:00:00'), valid_to: nil, value: true)
  end

  def down
    feature_flag = FeatureFlag.find_by(key: "era_oct_26")
    return if feature_flag.nil?

    feature_flag.destroy
  end
end
