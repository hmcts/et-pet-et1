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

  subject { described_class.new { |f| f.resource = claim; f.is_other_type_of_claim = true } }

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

  describe 'callbacks' do
    it 'clears other_claim_details when selecting no' do
      subject.other_claim_details = 'other details'
      subject.is_other_type_of_claim = false
      subject.run_callbacks(:save)

      expect(subject.other_claim_details).to be nil
    end
  end

  describe '#is_other_type_of_claim' do
    context 'when there are no other claim details' do
      it 'is false' do
        expect(subject.is_other_type_of_claim).to be false
      end
    end

    context 'when there is other claim details' do
      before { subject.other_claim_details = 'details' }

      it 'is true' do
        expect(subject.is_other_type_of_claim).to be true
      end
    end
  end
end
