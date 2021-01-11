require 'rails_helper'

RSpec.describe ClaimTypeForm, type: :form do

  it_behaves_like 'a Form',
    is_other_type_of_claim: true,
    is_unfair_dismissal: true,
    discrimination_claims: ['disability'],
    pay_claims: ['holiday'],
    is_whistleblowing: 'true',
    send_claim_to_whistleblowing_entity: 'false',
    other_claim_details: 'always'

  let(:claim_type_form) { described_class.new(claim) { |f| f.is_other_type_of_claim = 'true' } }

  let(:claim) do
    Claim.new \
      discrimination_claims: [:sex_including_equal_pay, :disability, :race],
      pay_claims: [:redundancy, :notice, :holiday, :arrears, :other]
  end

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
    context 'when there are no other claim details' do
      it 'is false' do
        expect(claim_type_form.is_other_type_of_claim).to be false
      end
    end

    context 'when there is other claim details' do
      before { claim_type_form.other_claim_details = 'details' }

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
    end

    context 'empty attributes' do
      it "will fail" do
        expect(claim_type_form.valid?).to be_falsey
      end

      it "will return proper error message" do
        claim_type_form.valid?
        expect(claim_type_form.errors.messages[:base].first).to eql('You must select at least one of the claim types below')
      end
    end

    it "is valid with 1 claim type" do
      claim_type_form.discrimination_claims = ["", "age"]
      expect(claim_type_form.valid?).to be_truthy
    end

    it "is valid with 2 or more claim types" do
      claim_type_form.discrimination_claims = ["", "age"]
      claim_type_form.is_unfair_dismissal = true
      expect(claim_type_form.valid?).to be_truthy
    end
  end
end
