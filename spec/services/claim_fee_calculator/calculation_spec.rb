require 'rails_helper'

RSpec.describe ClaimFeeCalculator::Calculation, type: :remissions do
  describe '#fee_to_pay?' do
    context 'when there is an application fee to pay after counting remission' do
      let(:subject) { described_class.new 1, 1, 1 }

      it 'is true' do
        expect(subject.fee_to_pay?).to be true
      end
    end

    context 'when there is no application fee to pay after counting remission' do
      let(:subject) { described_class.new 1, 1, 0 }

      it 'is false' do
        expect(subject.fee_to_pay?).to be false
      end
    end
  end
end
