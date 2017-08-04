module PaymentAndFee
  extend ActiveSupport::Concern

  delegate :fee_to_pay?, :application_fee,
    :application_fee_after_remission, to: :fee_calculation

  def attracts_higher_fee?
    discrimination_claims.any? || is_unfair_dismissal? || is_whistleblowing? || is_protective_award?
  end

  def fee_calculation
    ClaimFeeCalculator.calculate claim: self
  end

  def payment_applicable?
    # Due to court rulling for no fees
    false
  end

  def unpaid?
    payment.blank?
  end

  def remission_applicable?
    fee_calculation.application_fee != fee_calculation.application_fee_after_remission
  end

  def payment_fee_group_reference
    if payment_attempts.zero?
      fee_group_reference
    else
      "#{fee_group_reference}-#{payment_attempts}"
    end
  end

end
