module Admin
  module PaymentStatus
    def for(claim)
      if !claim.immutable?
        'Not submitted'
      elsif claim.remission_claimant_count.positive?
        'Remission indicated'
      elsif claim.payment_present?
        'Paid'
      else
        'Missing payment'
      end
    end

    module_function :for
  end
end
