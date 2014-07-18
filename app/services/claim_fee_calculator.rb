class ClaimFeeCalculator < Struct.new(:claim)
  Calculation = Struct.new(:application_fee, :hearing_fee)

  class << self
    def calculate(claim:)
      new(claim).calculate
    end
  end

  def calculate
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
end
