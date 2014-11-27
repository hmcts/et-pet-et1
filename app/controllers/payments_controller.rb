class PaymentsController < ApplicationController
  GATEWAY_RESPONSES = %i<success decline>.freeze

  redispatch_request unless: :payment_required?

  before_action :validate_request, only: GATEWAY_RESPONSES

  def payment_request
    @payment_request ||= PaymentGateway::Request.new request,
      amount: fee_calculation.application_fee_after_remission * 100,
      reference: claim.payment_fee_group_reference
  end

  def fee_calculation
    @fee_calculation ||= claim.fee_calculation
  end

  helper_method :payment_request, :fee_calculation

  # BarclayCard transaction result callback actions

  def success
    # Strip padding from FGR (FGRs are padded with an incrementing integer
    # when retrying failed transactions)
    reference = params['orderID'].sub(/\-\d+\Z/, '')
    claim     = Claim.find_by fee_group_reference: reference

    if payment_response.success?
      claim.create_payment amount: payment_response.amount, reference: payment_response.reference
    end

    claim.enqueue!
    redirect_to claim_confirmation_path
  end

  def decline
    flash[:alert] = t('.payment_declined')
    claim.increment! :payment_attempts
    redirect_to :action => :show
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
