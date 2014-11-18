require 'rails_helper'

RSpec.describe YourFeeForm, :type => :form do
  it_behaves_like("a Form", remission_claimant_count: 0)

  subject { described_class.new claim }
  let(:claim) { Claim.create }

  describe 'validations' do
    describe '#remission_claimant_count' do
      before { 10.times { claim.claimants.create } }

      context 'when it is > total number of claimants' do
        before do
          subject.remission_claimant_count = 11
          subject.valid?
        end

        it 'is not valid' do
          expect(subject.errors[:remission_claimant_count]).to include "must be less than or equal to 10"
        end
      end

      context 'when it is == total number of claimants' do
        before do
          subject.remission_claimant_count = 10
          subject.valid?
        end

        it 'is valid' do
          expect(subject.errors[:remission_claimant_count]).to be_empty
        end
      end

      context 'when it is < total number of claimants' do
        before do
          subject.remission_claimant_count = 9
          subject.valid?
        end

        it 'is valid' do
          expect(subject.errors[:remission_claimant_count]).to be_empty
        end
      end
    end
  end

  describe 'setting remission_claimant_count on save' do
    context 'when remission_claimant_count is nil' do
      before do
        subject.remission_claimant_count = nil
        subject.save
      end

      it 'sets remission_claimant_count as 0' do
        expect(subject.remission_claimant_count).to eq 0
      end
    end

    context 'when remission_claimant_count is not nil' do
      before do
        claim.create_primary_claimant
        subject.remission_claimant_count = 1
        subject.save
      end

      it 'sets remission_claimant_count as 0' do
        expect(subject.remission_claimant_count).to eq 1
      end
    end
  end

  describe '#applying_for_remission=' do
    describe 'when called with "true"' do
      before { subject.applying_for_remission = 'true' }

      it 'sets remission_claimant_count to 1' do
        expect(subject.remission_claimant_count).to eq 1
      end
    end

    describe 'when called with "false"' do
      before { subject.applying_for_remission = 'false' }

      it 'sets remission_claimant_count to 0' do
        expect(subject.remission_claimant_count).to eq 0
      end
    end
  end

  describe '#applying_for_remission' do
    context 'when remission_claimant_count is nil' do
      before { subject.remission_claimant_count = nil }

      it 'is nil' do
        expect(subject.applying_for_remission).to be nil
      end
    end

    context 'when remission_claimant_count is 0' do
      before { subject.remission_claimant_count = 0 }

      it 'is nil' do
        expect(subject.applying_for_remission).to be false
      end
    end

    context 'when remission_claimant_count is > 0' do
      before { subject.remission_claimant_count = 1 }

      it 'is nil' do
        expect(subject.applying_for_remission).to be true
      end
    end
  end
end
