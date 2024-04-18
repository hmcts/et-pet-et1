class Refund < ApplicationRecord
  attribute :applicant_date_of_birth, :gds_date_type
  attribute :et_issue_fee_payment_date, :gds_date_type
  attribute :et_hearing_fee_payment_date, :gds_date_type
  attribute :et_reconsideration_fee_payment_date, :gds_date_type
  attribute :eat_issue_fee_payment_date, :gds_date_type
  attribute :eat_hearing_fee_payment_date, :gds_date_type
  REFERENCE_START = 1_000_000

  def generate_application_reference
    last = self.class.maximum(:application_reference_number)
    last = REFERENCE_START if last.nil?
    self.application_reference_number = last + 1
    self.application_reference = "C#{application_reference_number}"
  end

  def generate_submitted_at
    self.submitted_at = Time.now.utc
  end

  def has_fees?
    [:et_issue_fee, :et_hearing_fee, :et_reconsideration_fee, :eat_issue_fee, :eat_hearing_fee].any? do |fee|
      send("#{fee}_present?")
    end
  end

  def total_fees
    [:et_issue_fee, :et_hearing_fee, :et_reconsideration_fee, :eat_issue_fee, :eat_hearing_fee].reduce(0) do |sum, fee|
      sum + (send(fee) || 0)
    end
  end

  def et_issue_fee_present?
    et_issue_fee.present? && et_issue_fee.positive?
  end

  def et_hearing_fee_present?
    et_hearing_fee.present? && et_hearing_fee.positive?
  end

  def et_reconsideration_fee_present?
    et_reconsideration_fee.present? && et_reconsideration_fee.positive?
  end

  def eat_issue_fee_present?
    eat_issue_fee.present? && eat_issue_fee.positive?
  end

  def eat_hearing_fee_present?
    eat_hearing_fee.present? && eat_hearing_fee.positive?
  end
end
