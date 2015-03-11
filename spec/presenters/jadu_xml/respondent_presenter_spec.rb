require 'rails_helper'

RSpec.describe JaduXml::RespondentPresenter, type: :presenter do
  let(:respondent) { create :respondent }
  subject { described_class.new respondent }

  describe 'decorated methods' do
    describe '#acas' do
      it 'returns the respondent to be consumed by the acas presenter' do
        expect(subject.acas).to eq respondent
      end
    end

    describe '#alt_phone_number' do
      it 'is an alias to the work_address_telephone_number' do
        expect(subject.alt_phone_number).to eq respondent.work_address_telephone_number
      end
    end
  end
end
