RSpec.describe ClaimFeeCalculator::Calculation, type: :remissions do
  describe '#fee_to_pay?' do
    context 'when application_fee_after_remission is > 0' do
      let(:subject) { ClaimFeeCalculator::Calculation.new 1, 1, 1 }

      it 'is true' do
        expect(subject.fee_to_pay?).to be true
      end
    end

    context 'when application_fee != application_fee_after_remission' do
      let(:subject) { ClaimFeeCalculator::Calculation.new 1, 1, 0 }

      it 'is false' do
        expect(subject.fee_to_pay?).to be false
      end
    end
  end
end
