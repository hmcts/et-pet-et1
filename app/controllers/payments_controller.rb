class PaymentsController < ApplicationController
  GATEWAY_RESPONSES = %i<success decline>.freeze

  before_action :ensure_payment_is_required
  before_action :validate_request, only: GATEWAY_RESPONSES

  helper_method def payment_request
    @payment_request ||= PaymentGateway::Request.new request,
      amount: fee_calculation.application_fee_after_remission * 100,
      reference: claim.fee_group_reference
  end

  helper_method def fee_calculation
    @fee_calculation ||= claim.fee_calculation
  end

  # BarclayCard transaction result callback actions

  def success
    claim = Claim.find_by fee_group_reference: params['orderID']

    if payment_response.success?
      claim.create_payment amount: payment_response.amount, reference: payment_response.reference
    end

    claim.enqueue!
    redirect_to claim_confirmation_path
  end

  def decline
    claim.enqueue!
    redirect_to claim_confirmation_path
  end

  private

  def payment_response
    @payment_response ||= PaymentGateway::Response.new request
  end

  def validate_request
    # Don't give anything away to attackers poking at the system
    render nothing: true unless payment_response.valid?
  end

  def ensure_payment_is_required
    render nothing: true unless claim.payment_required?
  end
end
