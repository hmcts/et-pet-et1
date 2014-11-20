require 'rails_helper'

RSpec.describe RespondentCollectionPresenter, type: :presenter do
  subject { described_class.new claim }

  let(:claim) do
    Claim.new { |c| c.secondary_respondents << Respondent.new }
  end

  describe '#additional_respondents' do
    context 'with secondary respondents' do
      it 'returns "Yes"' do
        expect(subject.additional_respondents).to eq 'Yes'
      end
    end

    context 'without secondary respondents' do
      before { claim.secondary_respondents.clear }

      it 'returns "No"' do
        expect(subject.additional_respondents).to eq 'No'
      end
    end
  end

  describe '#each_item' do
    it 'yields each attribute and name to block' do
      expect { |b| subject.each_item &b }.
        to yield_successive_args [:additional_respondents, 'Yes']
    end
  end

  describe '#children' do
    it 'encapsulates each secondary respondent in a respondent presenter' do
      expect(subject.children.first).to be_a RespondentCollectionPresenter::RespondentPresenter
      expect(subject.children.first.target).to eq claim.secondary_respondents.first
    end
  end
end
