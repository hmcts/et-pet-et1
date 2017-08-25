require 'rails_helper'

RSpec.describe ClaimOutcomeForm, type: :form do
  subject { described_class.new claim }

  let(:claim) do
    Claim.new desired_outcomes: [:compensation_only, :tribunal_recommendation]
  end

  describe 'validations' do
    context 'character lengths' do
      it { is_expected.to ensure_length_of(:other_outcome).is_at_most(2500) }
    end
  end

  it_behaves_like "a Form", desired_outcomes: "such hopeful success", other_outcome: "ferrari"

  describe "#desired_outcomes" do
    it 'returns the underlying attribute, mapped to_s' do
      expect(subject.desired_outcomes).
        to eq claim.desired_outcomes.map(&:to_s)
    end
  end
end
