require 'rails_helper'

RSpec.describe ClaimOutcomeForm, :type => :form do

  describe 'validations' do
    context 'character lengths' do
      it { is_expected.to ensure_length_of(:other_outcome).is_at_most(2500) }
    end
  end

  attributes = {
    desired_outcomes: "such hopeful success",
    other_outcome: "ferrari"
  }

  set_resource = proc do form.resource = target end

  it_behaves_like("a Form", attributes, set_resource)

end
