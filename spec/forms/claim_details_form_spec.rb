require 'rails_helper'

RSpec.describe ClaimDetailsForm, :type => :form do

  describe 'validations' do
    context 'presence' do
      it { is_expected.to validate_presence_of(:claim_details) }
    end

    context 'character lengths' do
      it { is_expected.to ensure_length_of(:claim_details).is_at_most(5000) }
      it { is_expected.to ensure_length_of(:other_known_claimant_names).is_at_most(350) }
    end
  end

  attributes = {
    claim_details: "I want to make a claim",
    other_known_claimants: true,
    other_known_claimant_names: "Edgar"
  }

  set_resource = proc do form.resource = target end

  it_behaves_like("a Form", attributes, set_resource)

end
