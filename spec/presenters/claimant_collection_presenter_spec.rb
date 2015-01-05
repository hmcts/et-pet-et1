require 'rails_helper'

RSpec.describe ClaimantCollectionPresenter, type: :presenter do
  subject { described_class.new claim }

  let(:claim) { create :claim }

  describe '#group_claim' do
    context 'with secondary claimants csv' do
      it 'returns "Yes"' do
        expect(subject.group_claim).to eq 'Yes'
      end
    end

    context 'with secondary claimants' do
      let(:claim)  { create :claim, :without_additional_claimants_csv, :with_secondary_claimants }

      it 'returns "Yes"' do
        expect(subject.group_claim).to eq 'Yes'
      end
    end

    context 'without secondary claimants' do
      let(:claim)  { create :claim, :single_claimant }

      it 'returns "No"' do
        expect(subject.group_claim).to eq 'No'
      end
    end
  end

  describe '#each_item' do
    it 'yields each attribute and name to block' do
      expect { |b| subject.each_item &b }.
        to yield_successive_args [:group_claim, 'Yes']
    end
  end

  describe '#children' do
    let(:claim)  { create :claim, :without_additional_claimants_csv, :with_secondary_claimants }

    it 'encapsulates each secondary claimant in a claimant presenter' do
      expect(subject.children.first).to be_a ClaimantCollectionPresenter::ClaimantPresenter
      expect(subject.children.first.target).to eq claim.secondary_claimants.first
    end
  end
end
