require 'rails_helper'

RSpec.describe ClaimTypeForm, type: :form do

  let(:claim) do
    Claim.new \
      discrimination_claims: [:sex_including_equal_pay, :disability, :race],
      pay_claims: [:redundancy, :notice, :holiday, :arrears, :other]
  end
  let(:claim_type_form) { described_class.new(claim) { |f| f.is_other_type_of_claim = 'true' } }

  it_behaves_like 'a Form',
                  is_other_type_of_claim: true,
                  is_unfair_dismissal: true,
                  discrimination_claims: ['disability'],
                  pay_claims: ['holiday'],
                  is_whistleblowing: 'true',
                  send_claim_to_whistleblowing_entity: 'false',
                  other_claim_details: 'always'

  [:pay, :discrimination].each do |type|
    describe "##{type}_claims" do
      it "returns an array of strings because that's what the form builder requires" do
        expect(claim_type_form.send("#{type}_claims")).
          to eq claim.send("#{type}_claims").map(&:to_s)
      end
    end
  end

  describe 'callbacks' do
    it 'clears other_claim_details when selecting no' do
      claim_type_form.other_claim_details = 'other details'
      claim_type_form.is_other_type_of_claim = false
      claim_type_form.valid?

      expect(claim_type_form.other_claim_details).to be nil
    end
  end

  describe '#is_other_type_of_claim' do
    context 'when there is other claim details' do
      before { claim_type_form.other_claim_details = 'details' }

      it { expect(claim_type_form).to validate_length_of(:other_claim_details).is_at_most(150) }

      it 'is true' do
        expect(claim_type_form.is_other_type_of_claim).to be true
      end
    end
  end

  describe "claim validation" do
    before do
      claim_type_form.is_unfair_dismissal = false
      claim_type_form.discrimination_claims = [""]
      claim_type_form.pay_claims = [""]
      claim_type_form.is_whistleblowing = false
      claim_type_form.send_claim_to_whistleblowing_entity = false
      claim_type_form.other_claim_details = ""
      claim_type_form.is_other_type_of_claim = false
    end

    context 'with empty attributes' do
      it "fails" do
        expect(claim_type_form).not_to be_valid
      end

      it "returns proper error message" do
        claim_type_form.valid?
        expect(claim_type_form.errors.messages[:base].first).to eql('You must select at least one of the claim types below')
      end
    end

    it "is valid with 1 claim type" do
      claim_type_form.discrimination_claims = ["", "age"]
      expect(claim_type_form).to be_valid
    end

    it "is valid with 2 or more claim types" do
      claim_type_form.discrimination_claims = ["", "age"]
      claim_type_form.is_unfair_dismissal = true
      expect(claim_type_form).to be_valid
    end
  end
end
