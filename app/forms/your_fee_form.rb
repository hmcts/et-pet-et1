class YourFeeForm < Form
  attribute :remission_claimant_count, :integer

  validates :remission_claimant_count, numericality: {
    less_than_or_equal_to: ->(form) { form.target.claimant_count },
    allow_blank: true
  }

  before_save ->(form) { form.remission_claimant_count = 0 }, unless: :remission_claimant_count?

  def secondary_claimants?
    target.secondary_claimants.any? || target.additional_claimants_csv_record_count.positive?
  end

  def applying_for_remission=(bool)
    bool = ActiveRecord::Type::Boolean.new.cast bool
    self.remission_claimant_count = bool ? 1 : 0
  end

  def applying_for_remission
    remission_claimant_count.try :>, 0
  end
end
