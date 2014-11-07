class ClaimFeeCalculator < Struct.new(:claim)
  class << self
    def calculate(claim:)
      new(claim).calculate
    end
  end

  def calculate
    application_fee_without_remission, hearing_fee =
      if claim.alleges_discrimination_or_unfair_dismissal?
        fee_calculation_for_discrimination_or_unfair_dismissal_claim
      else
        fee_calculation_for_other_claim
      end

    Calculation.new application_fee_without_remission, hearing_fee,
      RemissionCalculator.new(claim, application_fee_without_remission).application_fee_with_remission
  end

  private

  def fee_calculation_for_discrimination_or_unfair_dismissal_claim
    case claim.claimant_count
      when 0       then [0, 0]
      when 1       then [250, 950]
      when 2..10   then [500, 1900]
      when 11..200 then [1000, 3800]

      when 201..Float::INFINITY then [1500, 5700]
    end
  end

  def fee_calculation_for_other_claim
    case claim.claimant_count
      when 0       then [0, 0]
      when 1       then [160, 230]
      when 2..10   then [320, 460]
      when 11..200 then [640, 920]

      when 201..Float::INFINITY then [960, 1380]
    end
  end
end
