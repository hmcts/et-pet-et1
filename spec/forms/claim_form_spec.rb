require 'rails_helper'

RSpec.describe ClaimForm, :type => :form do
  describe 'validations' do
    it { is_expected.to ensure_length_of(:claim_details).is_at_most(5000) }
    it { is_expected.to ensure_length_of(:miscellaneous_information).is_at_most(5000) }
    it { is_expected.to ensure_length_of(:other_outcome).is_at_most(2500) }
    it { is_expected.to ensure_length_of(:other_known_claimant_names).is_at_most(350) }
  end

  describe '#save' do
    let(:resource) { double }
    let(:form) { ClaimForm.new(attributes) { |f| f.resource = resource } }

    let(:attributes) do
      { is_unfair_dismissal: "1",
        discrimination_claims: ["sex_including_equal_pay", "pregnancy_or_maternity", "marriage_or_civil_partnership", ""],
        pay_claims: ["redundancy", "notice", "holiday", "other", ""],
        other_claim_details: "lol", claim_details: "lewl",
        desired_outcomes: ["compensation_only", "new_employment_and_compensation", ""],
        other_outcome: "lelz",
        other_known_claimant_names: "hey",
        is_whistleblowing: "true",
        send_claim_to_whistleblowing_entity: "true",
        miscellaneous_information: "hey now!" }
    end

    describe 'for valid attributes' do
      it 'creates a new claim detail on the claim' do
        expect(resource).to receive(:build_claim_detail).with attributes
        expect(resource).to receive(:save)

        form.save
      end
    end
  end
end
