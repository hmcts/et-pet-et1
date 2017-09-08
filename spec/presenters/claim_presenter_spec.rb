require 'rails_helper'

RSpec.describe ClaimPresenter, type: :presenter do
  let(:claim_presenter) { described_class.new claim }

  let(:claim) { Claim.new }
  let(:sections) do
    ['claimant', 'additional_claimants', 'representative', 'respondent', 'additional_respondents', 'employment', 'claim_type', 'claim_details', 'claim_outcome', 'additional_information']
  end

  it 'encapsulates a collection of presenters corresponding to each section' do
    sections.each do |s|
      expect(claim_presenter.send(s)).to be_a Presenter
    end
  end

  describe '#each_section' do
    let(:presenters) { sections.map { |s| claim_presenter.send s } }

    it 'yields each section name and corresponding presenter' do
      expect { |b| claim_presenter.each_section(&b) }.
        to yield_successive_args(*sections.zip(presenters))
    end
  end

  describe 'additional claimants instance type' do
    let(:section) { 'additional_claimants' }

    context 'additionals csv is present' do
      before { claim.additional_claimants_csv = Tempfile.new('claimants.csv') }
      it "initializes a ClaimantCsvPresenter" do
        expect(claim_presenter.send(section)).to be_a ClaimantCsvPresenter
      end
    end

    context 'no csv present' do
      it "initializes a ClaimantCsvPresenter" do
        expect(claim_presenter.send(section)).to be_a ClaimantCollectionPresenter
      end
    end
  end
end
