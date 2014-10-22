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

  subject { described_class.new { |f| f.resource = claim } }

  let(:claim) do
    Claim.new \
      discrimination_claims: %i<sex_including_equal_pay disability race>,
      pay_claims: %i<redundancy notice holiday arrears other>
  end


  %i<pay discrimination>.each do |type|
    describe "##{type}_claims" do
      it 'returns the underlying attribute, mapped to_s' do
        expect(subject.send "#{type}_claims").
          to eq claim.send("#{type}_claims").map(&:to_s)
      end
    end
  end
end
