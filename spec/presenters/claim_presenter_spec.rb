require 'rails_helper'

RSpec.describe ClaimPresenter, type: :presenter do
  subject { described_class.new Claim.new }

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
end
