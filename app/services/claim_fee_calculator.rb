class ClaimFeeCalculator < Struct.new(:claim)
  Calculation = Struct.new(:application_fee, :hearing_fee)

  class << self
    def calculate(claim:)
      new(claim).calculate
    end
  end

  def calculate
    if claim.alleges_discrimination_or_unfair_dismissal?
      fee_calculation_for_discrimination_or_unfair_dismissal_claim
    else
      fee_calculation_for_other_claim
    end
  end

  private

  def fee_calculation_for_discrimination_or_unfair_dismissal_claim
    case claim.claimant_count
    when 1
      Calculation.new '£250', '£950'
    when 2..10
      Calculation.new '£500', '£1900'
    when 11..200
      Calculation.new '£1000', '£3800'
    when 201..Float::INFINITY
      Calculation.new '£1500', '£5700'
    end
  end

  def fee_calculation_for_other_claim
    case claim.claimant_count
    when 1
      Calculation.new '£160', '£230'
    when 2..10
      Calculation.new '£320', '£460'
    when 11..200
      Calculation.new '£640', '£920'
    when 201..Float::INFINITY
      Calculation.new '£960', '£1380'
    end
  end
end
