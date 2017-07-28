require "rails_helper"

RSpec.describe ClaimPagesManager, type: :service do
  let(:claim)   { Claim.new }
  let(:subject) { described_class.new resource: resource }

  describe '.first_page' do
    it 'returns the first page in the process' do
      expect(described_class.first_page).to eq('application-number')
    end
  end

  describe '.page_names' do
    it 'returns an array of managed page names' do
      expect(described_class.page_names).
        to eq %w<application-number claimant additional-claimants additional-claimants-upload
          representative respondent additional-respondents employment claim-type
          claim-details claim-outcome additional-information review>
    end
  end

  describe '#pages' do
    let(:resource) { ClaimantForm.new claim }

    it 'returns the total pages' do
      expect(subject.total_pages).to eq(11)
    end
  end

  describe '#forward' do
    context 'when resource is a ApplicationNumberForm' do
      let(:resource) { ApplicationNumberForm.new claim }
      its(:current_page)  { is_expected.to eq 1 }
      its(:forward)  { is_expected.to eq('claimant') }
    end

    context 'when resource is a ClaimantForm' do
      let(:resource) { ClaimantForm.new claim }
      its(:current_page)  { is_expected.to eq 2 }
      its(:forward) { is_expected.to eq('additional-claimants') }
    end

    context 'when resource is a AdditionalClaimantsForm' do
      let(:resource) { AdditionalClaimantsForm.new claim }
      its(:current_page)  { is_expected.to eq 3 }
      its(:forward)  { is_expected.to eq('representative') }
    end

    context 'when resource is a AdditionalClaimantsUploadForm' do
      let(:resource) { AdditionalClaimantsUploadForm.new claim }
      its(:current_page)  { is_expected.to eq 3 }
      its(:forward)  { is_expected.to eq('representative') }
    end

    context 'when resource is a RepresentativeForm' do
      let(:resource) { RepresentativeForm.new claim }
      its(:current_page)  { is_expected.to eq 4 }
      its(:forward)  { is_expected.to eq('respondent') }
    end

    context 'when resource is a RespondentForm' do
      let(:resource) { RespondentForm.new claim }
      its(:current_page)  { is_expected.to eq 5 }
      its(:forward) { is_expected.to eq('additional-respondents') }
    end

    context 'when resource is a AdditionalRespondentsForm' do
      let(:resource) { AdditionalRespondentsForm.new claim }
      its(:current_page)  { is_expected.to eq 6 }
      its(:forward) { is_expected.to eq('employment') }
    end

    context 'when resource is a EmploymentForm' do
      let(:resource) { EmploymentForm.new claim }
      its(:current_page)  { is_expected.to eq 7 }
      its(:forward)  { is_expected.to eq('claim-type') }
    end

    context 'when resource is a ClaimTypeForm' do
      let(:resource) { ClaimTypeForm.new claim }
      its(:current_page)  { is_expected.to eq 8 }
      its(:forward)  { is_expected.to eq('claim-details') }
    end

    context 'when resource is a ClaimDetailsForm' do
      let(:resource) { ClaimDetailsForm.new claim }
      its(:current_page)  { is_expected.to eq 9 }
      its(:forward)  { is_expected.to eq('claim-outcome') }
    end

    context 'when resource is a ClaimOutcomeForm' do
      let(:resource) { ClaimOutcomeForm.new claim }
      its(:current_page)  { is_expected.to eq 10 }
      its(:forward)  { is_expected.to eq('additional-information') }
    end

    context 'when resource is a AdditionalInformationForm' do
      let(:resource) { AdditionalInformationForm.new claim }
      its(:current_page)  { is_expected.to eq 11 }
      its(:forward)  { is_expected.to eq('review') }
    end
  end
end
