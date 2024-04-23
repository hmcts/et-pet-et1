require "rails_helper"

RSpec.describe ClaimPagesManager, type: :service do
  let(:claim) { Claim.new }
  let(:claim_pages_manager) { described_class.new resource: }

  describe '.first_page' do
    it 'returns the first page in the process' do
      expect(described_class.first_page).to eq('application-number')
    end
  end

  describe '.page_names' do
    it 'returns an array of managed page names' do
      expect(described_class.page_names).
        to eq ['application-number', 'claimant', 'additional-claimants', 'additional-claimants-upload', 'representative', 'respondent', 'additional-respondents', 'employment', 'claim-type', 'claim-details', 'claim-outcome', 'additional-information', 'review']
    end
  end

  describe '#pages' do
    let(:resource) { ClaimantForm.new claim }

    it 'returns the total pages' do
      expect(claim_pages_manager.total_pages).to eq(11)
    end
  end

  describe '#forward' do
    context 'when resource is a ApplicationNumberForm' do
      let(:resource) { ApplicationNumberForm.new claim }

      it { expect(claim_pages_manager.current_page).to eq 1 }
      it { expect(claim_pages_manager.forward).to eq('claimant') }
    end

    context 'when resource is a ClaimantForm' do
      let(:resource) { ClaimantForm.new claim }

      it { expect(claim_pages_manager.current_page).to eq 2 }
      it { expect(claim_pages_manager.forward).to eq('additional-claimants') }
    end

    context 'when resource is a AdditionalClaimantsForm' do
      let(:resource) { AdditionalClaimantsForm.new claim }

      it { expect(claim_pages_manager.current_page).to eq 3 }
      it { expect(claim_pages_manager.forward).to eq('representative') }
    end

    context 'when resource is a AdditionalClaimantsUploadForm' do
      let(:resource) { AdditionalClaimantsUploadForm.new claim }

      it { expect(claim_pages_manager.current_page).to eq 3 }
      it { expect(claim_pages_manager.forward).to eq('representative') }
    end

    context 'when resource is a RepresentativeForm' do
      let(:resource) { RepresentativeForm.new claim }

      it { expect(claim_pages_manager.current_page).to eq 4 }
      it { expect(claim_pages_manager.forward).to eq('respondent') }
    end

    context 'when resource is a RespondentForm' do
      let(:resource) { RespondentForm.new claim }

      it { expect(claim_pages_manager.current_page).to eq 5 }
      it { expect(claim_pages_manager.forward).to eq('additional-respondents') }
    end

    context 'when resource is a AdditionalRespondentsForm' do
      let(:resource) { AdditionalRespondentsForm.new claim }

      it { expect(claim_pages_manager.current_page).to eq 6 }
      it { expect(claim_pages_manager.forward).to eq('employment') }
    end

    context 'when resource is a EmploymentForm' do
      let(:resource) { EmploymentForm.new claim }

      it { expect(claim_pages_manager.current_page).to eq 7 }
      it { expect(claim_pages_manager.forward).to eq('claim-type') }
    end

    context 'when resource is a ClaimTypeForm' do
      let(:resource) { ClaimTypeForm.new claim }

      it { expect(claim_pages_manager.current_page).to eq 8 }
      it { expect(claim_pages_manager.forward).to eq('claim-details') }
    end

    context 'when resource is a ClaimDetailsForm' do
      let(:resource) { ClaimDetailsForm.new claim }

      it { expect(claim_pages_manager.current_page).to eq 9 }
      it { expect(claim_pages_manager.forward).to eq('claim-outcome') }
    end

    context 'when resource is a ClaimOutcomeForm' do
      let(:resource) { ClaimOutcomeForm.new claim }

      it { expect(claim_pages_manager.current_page).to eq 10 }
      it { expect(claim_pages_manager.forward).to eq('additional-information') }
    end

    context 'when resource is a AdditionalInformationForm' do
      let(:resource) { AdditionalInformationForm.new claim }

      it { expect(claim_pages_manager.current_page).to eq 11 }
      it { expect(claim_pages_manager.forward).to eq('review') }
    end
  end
end
