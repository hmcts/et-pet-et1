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
    Rails.logger.info "Claim #{id} #{application_reference}"\
    " payment_applicable gw: #{PaymentGateway.available?} fee_to_pay? "\
    "#{fee_to_pay?} fee_group_reference #{fee_group_reference?} "
    PaymentGateway.available? && fee_to_pay? && fee_group_reference?
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
