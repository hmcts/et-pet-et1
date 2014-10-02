require 'rails_helper'

describe ClaimForm do
  describe 'validations' do
    it { is_expected.to ensure_length_of(:claim_details).is_at_most(5000) }
    it { is_expected.to ensure_length_of(:miscellaneous_information).is_at_most(5000) }
    it { is_expected.to ensure_length_of(:other_outcome).is_at_most(2500) }
    it { is_expected.to ensure_length_of(:other_known_claimant_names).is_at_most(350) }
    it { is_expected.to validate_presence_of :claim_details }
end

  let(:attributes) {
    { is_unfair_dismissal: "1",
      discrimination_claims: ["sex_including_equal_pay", "pregnancy_or_maternity", "marriage_or_civil_partnership", ""],
      pay_claims: ["redundancy", "notice", "holiday", "other", ""],
      other_claim_details: "lol", claim_details: "lewl",
      desired_outcomes: ["compensation_only", "new_employment_and_compensation", ""],
      other_outcome: "lelz",
      other_known_claimant_names: "hey",
      is_whistleblowing: "true",
      send_claim_to_whistleblowing_entity: "true",
      miscellaneous_information: "hey now!"
    }
  }

  let(:resource) { double 'resource' }
  let(:form)     { described_class.new(attributes) { |f| f.resource = resource } }

  describe '.model_name_i18n_key' do
    specify do
      expect(described_class.model_name_i18n_key).
        to eq(described_class.model_name.i18n_key)
    end
  end

  describe '#column_for_attribute' do
    it 'delegates through to target resource' do
      expect(resource).to receive(:column_for_attribute).with(:lol)
      form.column_for_attribute :lol
    end
  end

  describe '#save' do
    describe 'for valid attributes' do
      it "saves the data" do
        # Allow double to receive attributes that have validators. It will
        # receive those messages on save because the validators call through to
        # them and in turn the target receives the message if the attribute is
        # blank
        ClaimForm.validators.flat_map(&:attributes).uniq.
          each { |a| allow(resource).to receive(a) }

        allow(resource).to receive(:save)
        expect(resource).to receive(:update_attributes).with attributes

        form.save
      end
    end

    describe 'for invalid attributes' do
      before { allow(form).to receive(:valid?).and_return false }

      it 'is not saved' do
        expect(resource).not_to receive(:update_attributes)
        form.save
      end
    end
  end
end
