# TODO: take a look at this rubocop warning
# rubocop:disable Style/StructInheritance
class ClaimFeeCalculator
  class Calculation < Struct.new(:application_fee, :hearing_fee, :application_fee_after_remission)
    def fee_to_pay?
      application_fee_after_remission.positive?
    end
  end
end
# TODO: take a look at this rubocop warning
# rubocop:enable Style/StructInheritance
