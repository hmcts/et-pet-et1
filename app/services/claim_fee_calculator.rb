class ClaimFeeCalculator < Struct.new(:claim)
  Calculation = Struct.new(:application_fee, :hearing_fee, :application_fee_after_remission)

  class << self
    def calculate(claim:)
      new(claim).calculate
    end
  end

  def calculate
    fees = if claim.alleges_discrimination_or_unfair_dismissal?
      fee_calculation_for_discrimination_or_unfair_dismissal_claim
    else
      fee_calculation_for_other_claim
    end

    Calculation.new *fees, remission_amount_for(fees.first)
  end

  private

  def fee_calculation_for_discrimination_or_unfair_dismissal_claim
    case claim.claimant_count
      when 1       then [250, 950]
      when 2..10   then [500, 1900]
      when 11..200 then [1000, 3800]

      when 201..Float::INFINITY then [1500, 5700]
    end
  end

  def fee_calculation_for_other_claim
    case claim.claimant_count
      when 1       then [160, 230]
      when 2..10   then [320, 460]
      when 11..200 then [640, 920]

      when 201..Float::INFINITY then [960, 1380]
    end
  end

  def remission_amount_for(amount)
    factor = case claim.claimant_count
      when 2..10   then 2
      when 11..200 then 4
      when 201..Float::INFINITY then 6
    end

    if factor && full_paying_claimant_count < factor
      amount / factor * full_paying_claimant_count
    else
      amount
    end
  end

  def full_paying_claimant_count
    claim.claimant_count - claim.remission_claimant_count
  end
end
