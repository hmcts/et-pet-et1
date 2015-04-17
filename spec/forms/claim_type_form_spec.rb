require 'rails_helper'

RSpec.describe ClaimTypeForm, :type => :form do

  it_behaves_like 'a Form', is_other_type_of_claim: true,
    is_unfair_dismissal: true, discrimination_claims: ['disability'],
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

  describe 'validations' do
    subject { described_class.new Claim.new }

    context 'no claim type is provided' do
      it 'adds a validation error' do
        subject.valid?
        expect(subject.errors[:base]).
          to include I18n.t 'activemodel.errors.models.claim_type.attributes.base.invalid'
      end
    end

    %i<is_unfair_dismissal is_whistleblowing>.each do |boolean_claim_type|
      context "#{boolean_claim_type} boolean option is selected" do
        before { subject.send "#{boolean_claim_type}=", 'true' }
        its(:valid?) { is_expected.to be_truthy }
      end
    end

    context 'other claim details have been provided' do
      before do
        subject.is_other_type_of_claim = 'true'
        subject.other_claim_details = 'such nonsense'
      end
      its(:valid?) { is_expected.to be_truthy }
    end

    { discrimination_claims: :disability, pay_claims: :notice }.each do |claim_type, issue|
      context "at least one option selected for the category: #{claim_type}" do
        before { subject.send "#{claim_type}=", issue }
        its(:valid?) { is_expected.to be_truthy }
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
end
