require "rails_helper"

RSpec.describe ClaimTransitionManager, type: :service do
  let(:subject) { described_class.new resource: resource }

  describe '#forward' do
    describe 'when resource is a PasswordForm' do
      let(:resource) { PasswordForm.new }
      its(:forward) { is_expected.to eq(:claimant) }
    end
  end

  describe 'when resource is a ClaimantForm' do
    let(:resource) { ClaimantForm.new }

    before { allow(resource).to receive(:has_representative).and_return true }
    its(:forward) { is_expected.to eq(:representative) }
  end

  describe 'when resource is a RepresentativeForm' do
    let(:resource) { RepresentativeForm.new }
    its(:forward)  { is_expected.to eq(:respondent) }
  end

  describe 'when resource is a RespondentForm' do
    let(:resource) { RespondentForm.new }

    before { allow(resource).to receive(:was_employed).and_return true }
    its(:forward) { is_expected.to eq(:employment) }
  end

  describe 'when resource is a EmploymentForm' do
    let(:resource) { EmploymentForm.new }
    its(:forward)  { is_expected.to eq(:claim_type) }
  end

  describe 'when resource is a ClaimTypeForm' do
    let(:resource) { ClaimTypeForm.new }
    its(:forward)  { is_expected.to eq(:claim_details) }
  end

  describe 'when resource is a ClaimDetailsForm' do
    let(:resource) { ClaimDetailsForm.new }
    its(:forward)  { is_expected.to eq(:claim_outcome) }
  end

  describe 'when resource is a ClaimOutcomeForm' do
    let(:resource) { ClaimOutcomeForm.new }
    its(:forward)  { is_expected.to eq(:additional_information) }
  end

  describe 'when resource is a AdditionalInformationForm' do
    let(:resource) { AdditionalInformationForm.new }
    its(:forward)  { is_expected.to eq(:review) }
  end
end
