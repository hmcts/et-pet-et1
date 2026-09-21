class FeatureFlagValue < ApplicationRecord
  belongs_to :feature_flag, primary_key: 'key', foreign_key: 'flag_key', required: false

  scope :active, lambda {
    now = Time.current
    where('valid_from IS NULL OR valid_from <= ?', now).
      where('valid_to IS NULL OR valid_to >= ?', now)
  }

  scope :newest_first, -> { order(created_at: :desc) }

  def self.current
    active.newest_first.first
  end
end
