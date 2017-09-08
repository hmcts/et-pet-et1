require 'rails_helper'

RSpec.describe JaduXml::RepresentativePresenter, type: :presenter do
  let(:jadu_xml_representative_presenter) { described_class.new representative }

  let(:representative) { create :representative }

  describe 'decorated methods' do
    describe '#claimant_or_respondent' do
      it 'returns C' do
        expect(jadu_xml_representative_presenter.claimant_or_respondent).to eq 'C'
      end
    end

    describe '#type' do
      it 'converts the type using a represnetative type mapper' do
        expect(RepresentativeType).to receive(:convert_for_jadu).
          with('law_centre').and_call_original
        jadu_xml_representative_presenter.type
      end

      it { expect(jadu_xml_representative_presenter.type).to eq 'Law Centre' }
    end
  end
end
