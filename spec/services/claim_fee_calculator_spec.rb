RSpec.describe ClaimFeeCalculator, type: :service do
  let(:claim) { Claim.new }
  let(:calculation) { ClaimFeeCalculator.calculate claim: claim }

  describe '.calculate' do
    describe 'calculating the application fee' do
      context 'with a single claimant' do
        before { allow(claim).to receive(:claimant_count).and_return 1 }

        it 'is £250' do
          expect(calculation.application_fee).to eq '£250'
        end
      end

      context "with 2..10 claimants" do
        before { allow(claim).to receive(:claimant_count).and_return *(2..10) }

        it "is £500" do
          (2..10).each { expect(calculation.application_fee).to eq '£500' }
        end
      end

      context "with 11..200 claimants" do
        before { allow(claim).to receive(:claimant_count).and_return *(11..200) }

        it "is £1000" do
          (11..200).each { expect(calculation.application_fee).to eq '£1000' }
        end
      end

      context 'with 201 or more claimants' do
        before { allow(claim).to receive(:claimant_count).and_return Float::INFINITY }

        it "is £1500" do
          expect(calculation.application_fee).to eq '£1500'
        end
      end
    end

    describe 'calculating the hearing fee' do
      context 'with a single claimant' do
        before { allow(claim).to receive(:claimant_count).and_return 1 }

        it 'is £950' do
          expect(calculation.hearing_fee).to eq '£950'
        end
      end

      context "with 2..10 claimants" do
        before { allow(claim).to receive(:claimant_count).and_return *(2..10) }

        it "is £1900" do
          (2..10).each { expect(calculation.hearing_fee).to eq '£1900' }
        end
      end

      context "with 11..200 claimants" do
        before { allow(claim).to receive(:claimant_count).and_return *(11..200) }

        it "is £3800" do
          (11..200).each { expect(calculation.hearing_fee).to eq '£3800' }
        end
      end

      context 'with 201 or more claimants' do
        before { allow(claim).to receive(:claimant_count).and_return Float::INFINITY }

        it "is £5700" do
          expect(calculation.hearing_fee).to eq '£5700'
        end
      end
    end
  end
end
