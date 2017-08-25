require 'rails_helper'

RSpec.describe YourFeeForm, type: :form do
  it_behaves_like("a Form", remission_claimant_count: 0)

  let(:your_fee_form) { described_class.new claim }
  let(:claim) { Claim.create }

  describe 'validations' do
    describe '#remission_claimant_count' do
      before { 10.times { claim.claimants.create } }

      context 'when it is > total number of claimants' do
        before do
          your_fee_form.remission_claimant_count = 11
          your_fee_form.valid?
        end

        it 'is not valid' do
          expect(your_fee_form.errors[:remission_claimant_count]).to include "must be less than or equal to 10"
        end
      end

      context 'when it is == total number of claimants' do
        before do
          your_fee_form.remission_claimant_count = 10
          your_fee_form.valid?
        end

        it 'is valid' do
          expect(your_fee_form.errors[:remission_claimant_count]).to be_empty
        end
      end

      context 'when it is < total number of claimants' do
        before do
          your_fee_form.remission_claimant_count = 9
          your_fee_form.valid?
        end

        it 'is valid' do
          expect(your_fee_form.errors[:remission_claimant_count]).to be_empty
        end
      end
    end
  end

  describe 'setting remission_claimant_count on save' do
    context 'when remission_claimant_count is nil' do
      before do
        your_fee_form.remission_claimant_count = nil
        your_fee_form.save
      end

      it 'sets remission_claimant_count as 0' do
        expect(your_fee_form.remission_claimant_count).to eq 0
      end
    end

    context 'when remission_claimant_count is not nil' do
      before do
        claim.create_primary_claimant
        your_fee_form.remission_claimant_count = 1
        your_fee_form.save
      end

      it 'sets remission_claimant_count as 0' do
        expect(your_fee_form.remission_claimant_count).to eq 1
      end
    end
  end

  describe '#secondary_claimants?' do
    context 'secondary_claimants' do
      before { claim.additional_claimants_csv_record_count = 0 }

      it 'returns true when not empty' do
        claim.secondary_claimants.create
        expect(your_fee_form.secondary_claimants?).to eq true
      end

      it 'returns false when empty' do
        claim.secondary_claimants.delete_all
        expect(your_fee_form.secondary_claimants?).to eq false
      end
    end

    context 'additional_claimants_csv_record_count' do
      before { claim.secondary_claimants.delete_all }

      it 'returns true when greater than zero' do
        claim.additional_claimants_csv_record_count = 1
        expect(your_fee_form.secondary_claimants?).to eq true
      end

      it 'returns false when zero' do
        claim.additional_claimants_csv_record_count = 0
        expect(your_fee_form.secondary_claimants?).to eq false
      end
    end
  end

  describe '#applying_for_remission=' do
    describe 'when called with "true"' do
      before { your_fee_form.applying_for_remission = 'true' }

      it 'sets remission_claimant_count to 1' do
        expect(your_fee_form.remission_claimant_count).to eq 1
      end
    end

    describe 'when called with "false"' do
      before { your_fee_form.applying_for_remission = 'false' }

      it 'sets remission_claimant_count to 0' do
        expect(your_fee_form.remission_claimant_count).to eq 0
      end
    end
  end

  describe '#applying_for_remission' do
    context 'when remission_claimant_count is nil' do
      before { your_fee_form.remission_claimant_count = nil }

      it 'is nil' do
        expect(your_fee_form.applying_for_remission).to be nil
      end
    end

    context 'when remission_claimant_count is 0' do
      before { your_fee_form.remission_claimant_count = 0 }

      it 'is nil' do
        expect(your_fee_form.applying_for_remission).to be false
      end
    end

    context 'when remission_claimant_count is > 0' do
      before { your_fee_form.remission_claimant_count = 1 }

      it 'is nil' do
        expect(your_fee_form.applying_for_remission).to be true
      end
    end
  end
end
