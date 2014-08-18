require 'rails_helper'

RSpec.describe ClaimPresenter, type: :presenter do
  subject { ClaimPresenter.new claim }

  let(:claim) do
    double 'claim',
      primary_claimant: double('claimant', lol: 'haha!'),
      representative: double('representative', lol: 'haha!'),
      primary_respondent: double('respondent', lol: 'haha!'),
      employment: double('employment', lol: 'haha!'),
      claim_detail: double('claim_detail', lol: 'haha!')
  end

  let(:sections)  { %w<claimant representative respondent employment claim_detail> }

  its(:claimant_has_representative)     { is_expected.to eq 'Yes' }
  its(:respondent_employed_by_employer) { is_expected.to eq 'Yes' }

  it 'encapsulates a collection of presenters corresponding to each section' do
    sections.each do |s|
      expect(subject.send s).to be_a "#{s}_presenter".classify.constantize
    end
  end

  it "delegates the encapsulated presenter's instance methods" do
    sections.each do |section|
      presenter = subject.send(section)
      methods   = presenter.class.instance_methods(false)

      methods.each do |method|
        expect(presenter).to receive method
        subject.send :"#{section}_#{method}"
      end
    end
  end

  context 'when underlying methods return `blank?` values' do
    let(:claim) do
      Claim.new
    end

    let(:values) do
      methods = ClaimPresenter.instance_methods(false)
      methods.delete :each_section

      methods.each { |meth| puts "#{meth}: #{subject.send meth}" }
      methods.map { |meth| subject.send meth }
    end

    specify 'all methods return a placeholder indicating information not supplied' do
      expect(values).to all match 'Not entered'
    end
  end

  describe '#each_section' do
    it 'yields each section name' do
      expect { |b| subject.each_section &b }.
        to yield_successive_args "claimant", "representative", "respondent",
          "employment", "claim_detail"
    end

    %w<representative employment>.each do |relation|
      context "when claim##{relation} is nil" do
        before { allow(claim).to receive(relation) }

        it "does not yield '#{relation}'" do
          expect { |b| subject.each_section &b }.
            to_not yield_successive_args relation
        end
      end
    end

    %w<claimant respondent claim_detail>.each do |relation|
      context "when claim##{relation} is nil" do
        before { allow(claim).to receive(relation) }

        it "still yields '#{relation}'" do
          expect { |b| subject.each_section &b }.
            to yield_successive_args "claimant", "representative", "respondent",
              "employment", "claim_detail"
        end
      end
    end
  end
end
