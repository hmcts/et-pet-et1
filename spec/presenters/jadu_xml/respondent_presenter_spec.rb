require 'rails_helper'

RSpec.describe JaduXml::RespondentPresenter, type: :presenter do
  let(:jadu_xml_respondent_presenter) { described_class.new respondent }

  let(:respondent) { create :respondent }

  describe 'decorated methods' do
    describe '#acas' do
      it 'returns the respondent to be consumed by the acas presenter' do
        expect(jadu_xml_respondent_presenter.acas).to eq respondent
      end
    end

    describe '#alt_phone_number' do
      it 'is an alias to the work_address_telephone_number' do
        expect(jadu_xml_respondent_presenter.alt_phone_number).to eq respondent.work_address_telephone_number
      end
    end
  end
end
