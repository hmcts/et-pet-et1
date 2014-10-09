require 'rails_helper'

RSpec.describe YourFeeForm, :type => :form do

  attributes = { applying_for_remission: true }

  set_resource = proc do
    allow(resource).to receive(:primary_claimant).and_return nil
    allow(resource).to receive(:build_primary_claimant).and_return target
  end

  it_behaves_like("a Form", attributes, set_resource)

end
