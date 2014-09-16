class ClaimFeeCalculator
  class RemissionCalculator < Struct.new(:claim, :full_application_fee)
    def application_fee_with_remission
      if claimant_count > 1
        calculate_for_multiple_claimants
      else
        calculate_for_individual_claimant
      end
    end

    private def calculate_for_multiple_claimants
      factor = case claimant_count
        when 2..10   then 2
        when 11..200 then 4
        when 201..Float::INFINITY then 6
      end

      if claimant_count - remission_claimant_count < factor
        (full_application_fee / factor) * (claimant_count - remission_claimant_count)
      else
        full_application_fee
      end
    end

    private def calculate_for_individual_claimant
      if claim.remission_claimant_count > 0
        0
      else
        full_application_fee
      end
    end

    delegate :claimant_count, :remission_claimant_count, to: :claim
  end
end
