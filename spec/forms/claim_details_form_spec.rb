require 'rails_helper'

RSpec.describe ClaimDetailsForm, :type => :form do
  subject { described_class.new Claim.new }

  describe 'validations' do
    context 'presence' do
      it { is_expected.to validate_presence_of(:claim_details) }
    end

    context 'character lengths' do
      it { is_expected.to ensure_length_of(:claim_details).is_at_most(5000) }
      it { is_expected.to ensure_length_of(:other_known_claimant_names).is_at_most(350) }
    end
  end

  describe '#other_known_claimants' do
    context 'when #other_known_claimant_names is blank' do
      it 'is false' do
        expect(subject.other_known_claimants).to be false
      end
    end

    context 'when #other_known_claimant_names is not blank' do
      before { subject.other_known_claimant_names = "Lolly Lollington" }

      it 'is true' do
        expect(subject.other_known_claimants).to be true
      end
    end
  end

  it_behaves_like "a Form",
    claim_details: "I want to make a claim", other_known_claimants: 'true',
    other_known_claimant_names: "Edgar"

end
