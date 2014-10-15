require 'rails_helper'

RSpec.describe ClaimPresenter, type: :presenter do
  subject { described_class.new claim }

  let(:claim) do
    Claim.new \
      primary_claimant: Claimant.new,
      representative: Representative.new,
      primary_respondent: Respondent.new,
      employment: Employment.new
  end

  let(:sections) do
     %w<claimant representative respondent employment
      claim_type claim_details claim_outcome additional_information your_fee>
  end

  it 'encapsulates a collection of presenters corresponding to each section' do
    sections.each do |s|
      expect(subject.send s).to be_a "#{s}_presenter".classify.constantize
    end
  end

  describe '#each_section' do
    let(:presenters) { sections.map { |s| subject.send s} }

    it 'yields each section name and corresponding presenter' do
      expect { |b| subject.each_section &b }.
        to yield_successive_args *sections.zip(presenters)
    end

    %w<representative employment>.each do |relation|
      context "when claim##{relation} is nil" do
        before { allow(claim).to receive(relation) }

        let(:sections) do
          %w<claimant representative respondent employment
           claim_type claim_details claim_outcome additional_information
           your_fee> - [relation]
        end

        it "does not yield '#{relation}'" do
          expect { |b| subject.each_section &b }.
            to yield_successive_args *sections.zip(presenters)
        end
      end
    end

    %w<primary_claimant primary_respondent>.each do |relation|
      context "when claim##{relation} is nil" do
        before { allow(claim).to receive(relation) }

        it "still yields '#{relation}'" do
          expect { |b| subject.each_section &b }.
            to yield_successive_args *sections.zip(presenters)
        end
      end
    end
  end
end
