require 'rails_helper'

RSpec.describe ClaimantCollectionPresenter, type: :presenter do
  subject { described_class.new claim }

  let(:claim) do
    Claim.new { |c| c.secondary_claimants << Claimant.new }
  end

  describe '#group_claim' do
    context 'with secondary claimants' do
      it 'returns "Yes"' do
        expect(subject.group_claim).to eq 'Yes'
      end
    end

    context 'without secondary claimants' do
      before { claim.secondary_claimants.clear }

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
    it 'encapsulates each secondary claimant in a claimant presenter' do
      expect(subject.children.first).to be_a ClaimantCollectionPresenter::ClaimantPresenter
      expect(subject.children.first.target).to eq claim.secondary_claimants.first
    end
  end
end
