class ClaimFeeCalculator
  class Calculation < Struct.new(:application_fee, :hearing_fee, :application_fee_after_remission)
    def fee_to_pay?
      application_fee_after_remission > 0
    end
  end
end
