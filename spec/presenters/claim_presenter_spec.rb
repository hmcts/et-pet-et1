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

  describe '#skip?' do
    context 'when the underlying presenter has a nil target' do
      let(:claim) { double 'claim', primary_claimant: nil }
      specify { expect(subject.skip? :claimant).to be true }
    end

    context 'when the underlying presenter has a nil target' do
      specify { expect(subject.skip? :claimant).to be false }
    end
  end
end
