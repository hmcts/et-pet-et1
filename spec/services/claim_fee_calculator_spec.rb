RSpec.describe ClaimFeeCalculator, type: :remissions do
  let(:claim) { Claim.new }

  def calculation
    described_class.calculate claim: claim
  end

  describe '.calculate' do
    describe 'calculating the application fee' do
      context 'when the claim pertains to discrimination or unfair dismissal' do
        before do
          allow(claim).
            to receive(:alleges_discrimination_or_unfair_dismissal?).
            and_return true
        end

        context 'with a single claimant' do
          before { allow(claim).to receive(:claimant_count).and_return 1 }

          it 'is 250' do
            expect(calculation.application_fee).to eq 250
          end
        end

        context "with 2..10 claimants" do
          before { allow(claim).to receive(:claimant_count).and_return *(2..10) }

          it "is 500" do
            (2..10).each { expect(calculation.application_fee).to eq 500 }
          end
        end

        context "with 11..200 claimants" do
          before { allow(claim).to receive(:claimant_count).and_return *(11..200) }

          it "is 1000" do
            (11..200).each { expect(calculation.application_fee).to eq 1000 }
          end
        end

        context 'with 201 or more claimants' do
          before { allow(claim).to receive(:claimant_count).and_return Float::INFINITY }

          it "is 1500" do
            expect(calculation.application_fee).to eq 1500
          end
        end
      end

      context 'when the claim does not pertain to discrimination or unfair dismissal' do
        before do
          allow(claim).
            to receive(:alleges_discrimination_or_unfair_dismissal?).
            and_return false
        end

        context 'with a single claimant' do
          before { allow(claim).to receive(:claimant_count).and_return 1 }

          it 'is 160' do
            expect(calculation.application_fee).to eq 160
          end
        end

        context "with 2..10 claimants" do
          before { allow(claim).to receive(:claimant_count).and_return *(2..10) }

          it "is 320" do
            (2..10).each { expect(calculation.application_fee).to eq 320 }
          end
        end

        context "with 11..200 claimants" do
          before { allow(claim).to receive(:claimant_count).and_return *(11..200) }

          it "is 640" do
            (11..200).each { expect(calculation.application_fee).to eq 640 }
          end
        end

        context 'with 201 or more claimants' do
          before { allow(claim).to receive(:claimant_count).and_return Float::INFINITY }

          it "is 960" do
            expect(calculation.application_fee).to eq 960
          end
        end
      end
    end

    describe 'calculating the hearing fee' do
      context 'when the claim pertains to discrimination or unfair dismissal' do
        before do
          allow(claim).
            to receive(:alleges_discrimination_or_unfair_dismissal?).
            and_return true
        end

        context 'with a single claimant' do
          before { allow(claim).to receive(:claimant_count).and_return 1 }

          it 'is 950' do
            expect(calculation.hearing_fee).to eq 950
          end
        end

        context "with 2..10 claimants" do
          before { allow(claim).to receive(:claimant_count).and_return *(2..10) }

          it "is 1900" do
            (2..10).each { expect(calculation.hearing_fee).to eq 1900 }
          end
        end

        context "with 11..200 claimants" do
          before { allow(claim).to receive(:claimant_count).and_return *(11..200) }

          it "is 3800" do
            (11..200).each { expect(calculation.hearing_fee).to eq 3800 }
          end
        end

        context 'with 201 or more claimants' do
          before { allow(claim).to receive(:claimant_count).and_return Float::INFINITY }

          it "is 5700" do
            expect(calculation.hearing_fee).to eq 5700
          end
        end
      end

      context 'when the claim does not pertain to discrimination or unfair dismissal' do
        before do
          allow(claim).
            to receive(:alleges_discrimination_or_unfair_dismissal?).
            and_return false
        end

        context 'with a single claimant' do
          before { allow(claim).to receive(:claimant_count).and_return 1 }

          it 'is 230' do
            expect(calculation.hearing_fee).to eq 230
          end
        end

        context "with 2..10 claimants" do
          before { allow(claim).to receive(:claimant_count).and_return *(2..10) }

          it "is 460" do
            (2..10).each { expect(calculation.hearing_fee).to eq 460 }
          end
        end

        context "with 11..200 claimants" do
          before { allow(claim).to receive(:claimant_count).and_return *(11..200) }

          it "is 920" do
            (11..200).each { expect(calculation.hearing_fee).to eq 920 }
          end
        end

        context 'with 201 or more claimants' do
          before { allow(claim).to receive(:claimant_count).and_return Float::INFINITY }

          it "is 1380" do
            expect(calculation.hearing_fee).to eq 1380
          end
        end
      end
    end

    describe 'calculating the application fee with remission' do
      context 'for a single claimant who is claiming remission' do
        before do
          allow(claim).to receive(:claimant_count).and_return 1
          allow(claim).to receive(:remission_claimant_count).and_return 1
        end

        it 'is 0, i.e. 100% remission' do
          expect(calculation.application_fee_after_remission).to eq 0
        end
      end

      context 'for 2..10 claimants' do
        context 'when number_of_claimants - number_of_claimants_applying_for_remission' do
          context 'is less than or equal to 2' do
            it 'is equal to regular_fee / 2 * (number_of_claimants - number_of_claimants_applying_for_remission)' do
              (2..10).each do |claimant_count|
                (1..2).each do |delta|
                  allow(claim).to receive(:remission_claimant_count).and_return claimant_count - delta
                  allow(claim).to receive(:claimant_count).and_return claimant_count

                  expect(calculation.application_fee_after_remission).
                    to eq(calculation.application_fee / 2 * (claim.claimant_count - claim.remission_claimant_count))
                end
              end
            end
          end

          context 'is greater than 2' do
            it 'is equal to the regular fee' do
              (2..10).each do |claimant_count|
                (3..claimant_count).each do |delta|
                  allow(claim).to receive(:remission_claimant_count).and_return claimant_count - delta
                  allow(claim).to receive(:claimant_count).and_return claimant_count

                  expect(calculation.application_fee_after_remission).
                    to eq calculation.application_fee
                end
              end
            end
          end
        end
      end

      context "with 11..200 claimants" do
        context 'when number of claimants - number of claimants applying for remission' do
          context 'is less than or equal to 4' do
            it 'is equal to regular_fee / 4 * (number_of_claimants - number_of_claimants_applying_for_remission)' do
              (11..200).each do |claimant_count|
                (1..4).each do |delta|
                  allow(claim).to receive(:remission_claimant_count).and_return claimant_count - delta
                  allow(claim).to receive(:claimant_count).and_return claimant_count

                  expect(calculation.application_fee_after_remission).
                    to eq(calculation.application_fee / 4 * (claim.claimant_count - claim.remission_claimant_count))
                end
              end
            end
          end

          context 'is greater than 4' do
            it 'is equal to the regular fee' do
              (11..200).each do |claimant_count|
                # Would prefer to loop 5..claimant_count but that would be O(n^2)
                allow(claim).to receive(:remission_claimant_count).and_return 5
                allow(claim).to receive(:claimant_count).and_return claimant_count

                expect(calculation.application_fee_after_remission).
                  to eq calculation.application_fee
              end
            end
          end
        end
      end

      context "with 201 or more claimants" do
        context 'when number of claimants - number of claimants applying for remission' do
          let(:claimant_count) { 201 }
          context 'is less than or equal to 6' do

            it 'is equal to regular_fee / 6 * (number_of_claimants - number_of_claimants_applying_for_remission)' do
              (1..6).each do |delta|
                allow(claim).to receive(:remission_claimant_count).and_return claimant_count - delta
                allow(claim).to receive(:claimant_count).and_return claimant_count

                expect(calculation.application_fee_after_remission).
                  to eq(calculation.application_fee / 6 * (claim.claimant_count - claim.remission_claimant_count))
              end
            end
          end

          context 'is greater than 6' do
            it 'is equal to the regular fee' do
              allow(claim).to receive(:remission_claimant_count).and_return 7
              allow(claim).to receive(:claimant_count).and_return claimant_count

              expect(calculation.application_fee_after_remission).
                to eq calculation.application_fee
            end
          end
        end
      end
    end
  end
end
