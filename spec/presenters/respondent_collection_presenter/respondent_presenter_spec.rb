require 'rails_helper'

RSpec.describe RespondentCollectionPresenter::RespondentPresenter, type: :presenter do
  let(:subject) { described_class.new respondent }

  let(:respondent) do
    Respondent.new name: 'Lol Corp', address_building: '1', address_street: 'Lol street',
                   address_locality: 'Lolzville', address_county: 'Lolzfordshire',
                   address_post_code: 'LOL B1Z', acas_early_conciliation_certificate_number: '123'
  end

  its(:name) { is_expected.to eq('Lol Corp') }

  describe '#address' do
    it 'concatenates all address properties with a <br /> tag' do
      expect(subject.address).
        to eq('1<br />Lol street<br />Lolzville<br />Lolzfordshire<br />LOL B1Z<br />')
    end
  end

  describe '#acas_early_conciliation_certificate_number' do
    its(:acas_early_conciliation_certificate_number) do
      is_expected.to eq '123'
    end

    context 'when target.acas_number_reason is nil' do
      before do
        respondent.
          assign_attributes acas_early_conciliation_certificate_number: '',
                            no_acas_number_reason: :acas_has_no_jurisdiction
      end

      its(:acas_early_conciliation_certificate_number) do
        is_expected.
          to eq("Acas doesn’t have the power to conciliate on some or all of my claim")
      end
    end
  end
end
