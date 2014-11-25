require 'rails_helper'

RSpec.describe ClaimPresenter, type: :presenter do
  let(:claim) { Claim.new }
  subject { described_class.new claim }

  let(:sections) do
    %w<
      claimant additional_claimants representative respondent additional_respondents
      employment claim_type claim_details claim_outcome additional_information your_fee
    >
  end

  it 'encapsulates a collection of presenters corresponding to each section' do
    sections.each do |s|
      expect(subject.send s).to be_a Presenter
    end
  end

  describe '#each_section' do
    let(:presenters) { sections.map { |s| subject.send s } }

    it 'yields each section name and corresponding presenter' do
      expect { |b| subject.each_section &b }.
        to yield_successive_args *sections.zip(presenters)
    end
  end

  describe 'additional claimants instance type' do
    let(:section) { 'additional_claimants' }

    context 'additionals csv is present' do
      before { claim.additional_claimants_csv = Tempfile.new('claimants.csv') }
      it "initializes a ClaimantCsvPresenter" do
        expect(subject.send section).to be_a ClaimantCsvPresenter
      end
    end

    context 'no csv present' do
      it "initializes a ClaimantCsvPresenter" do
        expect(subject.send section).to be_a ClaimantCollectionPresenter
      end
    end
  end
end
