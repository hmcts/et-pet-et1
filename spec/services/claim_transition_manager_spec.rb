require "rails_helper"

RSpec.describe ClaimTransitionManager, type: :service do
  let(:subject) { described_class.new resource: resource }

  describe '.first_page' do
    it 'returns the first page in the process' do
      expect(described_class.first_page).to eq(:application_number)
    end
  end

  describe '#current_page' do
    let(:resource) { ApplicationNumberForm.new }

    it 'returns the current page based on the current transition' do
      expect(subject.current_page).to eq(1)
    end
  end

  describe '#pages' do
    let(:resource) { ClaimantForm.new }

    it 'returns the total pages (based on the number of rules)' do
      expect(subject.total_pages).to eq(10)
    end
  end

  describe '#forward' do

    context 'when resource is a RepresentativeForm' do
      let(:resource) { ApplicationNumberForm.new }
      its(:forward)  { is_expected.to eq(:claimant) }
    end

    context 'when resource is a ClaimantForm' do
      let(:resource) { ClaimantForm.new }
      its(:forward) { is_expected.to eq(:representative) }
    end

    context 'when resource is a RepresentativeForm' do
      let(:resource) { RepresentativeForm.new }
      its(:forward)  { is_expected.to eq(:respondent) }
    end

    context 'when resource is a RespondentForm' do
      let(:resource) { RespondentForm.new }
      its(:forward) { is_expected.to eq(:employment) }
    end

    context 'when resource is a EmploymentForm' do
      let(:resource) { EmploymentForm.new }
      its(:forward)  { is_expected.to eq(:claim_type) }
    end

    context 'when resource is a ClaimTypeForm' do
      let(:resource) { ClaimTypeForm.new }
      its(:forward)  { is_expected.to eq(:claim_details) }
    end

    context 'when resource is a ClaimDetailsForm' do
      let(:resource) { ClaimDetailsForm.new }
      its(:forward)  { is_expected.to eq(:claim_outcome) }
    end

    context 'when resource is a ClaimOutcomeForm' do
      let(:resource) { ClaimOutcomeForm.new }
      its(:forward)  { is_expected.to eq(:additional_information) }
    end

    context 'when resource is a AdditionalInformationForm' do
      let(:resource) { AdditionalInformationForm.new }
      its(:forward)  { is_expected.to eq(:your_fee) }
    end

    context 'when resource is a YourFeeForm' do
      let(:resource) { YourFeeForm.new }
      its(:forward)  { is_expected.to eq(:review) }
    end
  end
end
