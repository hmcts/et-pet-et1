class ClaimFeeCalculator
  class Calculation
    attr_reader :application_fee, :hearing_fee, :application_fee_after_remission

    def initialize(application_fee, hearing_fee, application_fee_after_remission)
      @application_fee = application_fee
      @hearing_fee = hearing_fee
      @application_fee_after_remission = application_fee_after_remission
    end

    def fee_to_pay?
      application_fee_after_remission.positive?
    end
  end
end
