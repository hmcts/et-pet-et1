class PaymentsController < ApplicationController
  before_action :ensure_payment_is_required

  helper_method def payment_request
    @payment_request ||= PaymentGateway::Request.new request,
      amount: fee_calculation.application_fee_after_remission * 100,
      reference: claim.fee_group_reference
  end

  helper_method def fee_calculation
    @fee_calculation ||= ClaimFeeCalculator.calculate claim: claim
  end

  private def ensure_payment_is_required
    render nothing: true unless claim.payment_required?
  end
end
