require 'rails_helper'

RSpec.describe ClaimTypeForm, :type => :form do

  it_behaves_like 'a Form', is_other_type_of_claim: true,
    is_unfair_dismissal: true,
    is_protective_award: false,
    discrimination_claims: ['disability'],
    pay_claims: ['holiday'],
    is_whistleblowing: 'true',
    send_claim_to_whistleblowing_entity: 'false',
    other_claim_details: 'always'

  subject { described_class.new(claim) { |f| f.is_other_type_of_claim = 'true' } }

  let(:claim) do
    Claim.new \
      discrimination_claims: %i<sex_including_equal_pay disability race>,
      pay_claims: %i<redundancy notice holiday arrears other>
  end

  %i<pay discrimination>.each do |type|
    describe "##{type}_claims" do
      it "returns an array of strings because that's what the form builder requires" do
        expect(subject.send "#{type}_claims").
          to eq claim.send("#{type}_claims").map(&:to_s)
      end
    end
  end

  describe 'callbacks' do
    it 'clears other_claim_details when selecting no' do
      subject.other_claim_details = 'other details'
      subject.is_other_type_of_claim = false
      subject.valid?

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

  describe "claim validation" do
    before do
      subject.is_unfair_dismissal = false
      subject.is_protective_award = false
      subject.discrimination_claims = [""]
      subject.pay_claims = [""]
      subject.is_whistleblowing = false
      subject.send_claim_to_whistleblowing_entity = false
      subject.other_claim_details = ""
    end

    context 'empty attributes' do
      it "will fail" do
        expect(subject.valid?).to be_falsey
      end

      it "will return proper error message" do
        expect(subject.valid?).to be_falsey
        expect(subject.errors.messages[:base].first).to eql('You must select at least one of the claim types below')
      end
    end

    it "is valid with 1 claim type" do
      subject.discrimination_claims = ["", "age"]
      expect(subject.valid?).to be_truthy
    end

    it "is valid with 2 or more claim types" do
      subject.discrimination_claims = ["", "age"]
      subject.is_unfair_dismissal = true
      expect(subject.valid?).to be_truthy
    end
  end
end
