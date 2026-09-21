class FeatureFlag < ApplicationRecord
  has_many :values, dependent: :destroy, class_name: 'FeatureFlagValue', primary_key: 'key', foreign_key: 'flag_key'

  def self.value_for(key)
    return Current.feature_flag_values[key] if Current.feature_flag_values.key?(key)

    value_record = ::FeatureFlagValue.where(flag_key: key).current
    return Current.feature_flag_values[key] = value_record.value if value_record

    flag_record = where(key:).first
    Current.feature_flag_values[key] = flag_record ? flag_record.default_value : false
  end
end
