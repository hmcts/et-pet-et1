class PaymentsController < ApplicationController
  GATEWAY_RESPONSES = [:success, :decline].freeze

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

  delegate :amount, :reference, :status, :success?, to: :payment_response

  def success
    if success?
      claim.create_payment amount: amount, reference: reference
      claim.create_event Event::PAYMENT_RECEIVED
    else
      # Barclaycard can still push requests to this end point even if there
      # is no guarantee the transaction was successful.
      claim.create_event Event::PAYMENT_UNCERTAIN, message: payment_uncertain_message
    end

    claim.enqueue!
    redirect_to claim_confirmation_path
  end

  def decline
    claim.create_event Event::PAYMENT_DECLINED
    flash[:alert] = t('.payment_declined')
    claim.increment! :payment_attempts
    redirect_to action: :show
  end

  private

  def payment_response
    @payment_response ||= PaymentGateway::Response.new request
  end

  def validate_request
    unless payment_response.valid?
      order = params['orderID']
      status = params['STATUS']
      message = "Failed to recognize payment order: #{order}, status: #{status}"
      Raven.capture_exception(message)
      # Don't give anything away to attackers poking at the system
      head :ok
    end
  end

  def payment_uncertain_message
    I18n.t(status, scope: 'barclaycard_gateway.responses', default: :generic, status: status)
  end

  # We want to be able to process a payment even if the session expired
  def claim
    # Strip padding from FGR (FGRs are padded with an incrementing integer
    # when retrying failed transactions)
    @claim ||= begin
      if params['orderID'].present?
        Claim.find_by fee_group_reference: params['orderID'].sub(/\-\d+\Z/, '')
      else
        super
      end
    end
  end
end
