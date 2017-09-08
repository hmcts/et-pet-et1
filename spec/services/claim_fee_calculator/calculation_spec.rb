require 'rails_helper'

RSpec.describe ClaimFeeCalculator::Calculation, type: :remissions do
  let(:claim_fee_calculator_calculation) { described_class.new 1, 1, application_fee_after_remission }

  describe '#fee_to_pay?' do
    context 'when there is an application fee to pay after counting remission' do
      let(:application_fee_after_remission) { 1 }

      it 'is true' do
        expect(claim_fee_calculator_calculation.fee_to_pay?).to be true
      end
    end

    context 'when there is no application fee to pay after counting remission' do
      let(:application_fee_after_remission) { 0 }

      it 'is false' do
        expect(claim_fee_calculator_calculation.fee_to_pay?).to be false
      end
    end
  end
end
