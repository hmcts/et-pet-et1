# TODO: take a look at this rubocop warning
# rubocop:disable Style/StructInheritance
class ClaimFeeCalculator
  class RemissionCalculator < Struct.new(:claim, :full_application_fee)
    def application_fee_with_remission
      if claimant_count > 1
        calculate_for_multiple_claimants
      else
        calculate_for_individual_claimant
      end
    end

    private

    def calculate_for_multiple_claimants
      if non_remission_claimant_count < multiple_claimant_factor
        (full_application_fee / multiple_claimant_factor) * non_remission_claimant_count
      else
        full_application_fee
      end
    end

    def calculate_for_individual_claimant
      if claim.remission_claimant_count.positive?
        0
      else
        full_application_fee
      end
    end

    def multiple_claimant_factor
      case claimant_count
      when 2..10   then 2
      when 11..200 then 4
      when 201..Float::INFINITY then 6
      end
    end

    def non_remission_claimant_count
      claimant_count - remission_claimant_count
    end

    delegate :claimant_count, :remission_claimant_count, to: :claim
  end
end
# rubocop:enable Style/StructInheritance
