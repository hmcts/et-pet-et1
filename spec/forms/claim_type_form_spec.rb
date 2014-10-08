require 'rails_helper'

RSpec.describe ClaimTypeForm, :type => :form do

  attributes = {
    is_other_type_of_claim: true,
    is_unfair_dismissal: true,
    discrimination_claims: "Disability",
    pay_claims: "Holiday",
    is_whistleblowing: true,
    send_claim_to_whistleblowing_entity: false,
    other_claim_details: "always"
  }

  set_resource = proc do form.resource = target end

  it_behaves_like("a Form", attributes, set_resource)

end
