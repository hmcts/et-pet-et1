require "rails_helper"

RSpec.describe ClaimTransitionManager, type: :service do
  let(:subject) { ClaimTransitionManager.new resource: resource }

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

    context 'when form#was_employed == false' do
      before { allow(resource).to receive(:was_employed).and_return false }
      its(:forward) { is_expected.to eq(:claim) }
    end

    context 'when form#was_employed == true' do
      before { allow(resource).to receive(:was_employed).and_return true }
      its(:forward) { is_expected.to eq(:employment) }
    end
  end

  describe 'when resource is a EmploymentForm' do
    let(:resource) { EmploymentForm.new }
    its(:forward)  { is_expected.to eq(:claim) }
  end

  describe 'when resource is a ClaimForm' do
    let(:resource) { ClaimForm.new }
    its(:forward)  { is_expected.to eq(:review) }
  end
end
