class ClaimConfirmationsController < ApplicationController
  redispatch_request unless: :immutable?

  def fee_calculation
    @fee_calculation ||= claim.fee_calculation
  end

  helper_method :fee_calculation
end
