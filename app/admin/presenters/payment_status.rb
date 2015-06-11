module Admin
  module PaymentStatus
    def for(claim)
      case
      when !claim.immutable?
        'Not submitted'
      when claim.remission_claimant_count > 0
        'Remission indicated'
      when claim.payment_present?
        'Paid'
      else
        'Missing payment'
      end
    end

    extend self
  end
end
