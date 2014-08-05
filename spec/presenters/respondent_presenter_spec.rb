require 'rails_helper'

RSpec.describe RespondentPresenter, type: :presenter do
  subject { RespondentPresenter.new respondent }

  let(:respondent) do
    double 'respondent',
      name: 'Lol Corp', address_building: '1', address_street: 'Lol street',
      address_locality: 'Lolzville', address_county: 'Lolzfordshire',
      address_post_code: 'LOL B1Z', address_telephone_number: '01234567890',
      acas_early_conciliation_certificate_number: '123',
      no_acas_number_reason: :acas_has_no_jurisdiction
  end

  its(:name) { is_expected.to eq('Lol Corp') }

  describe '#address' do
    it 'concatenates all address properties with a <br> tag' do
      expect(subject.address).
        to eq('1<br>Lol street<br>Lolzville<br>Lolzfordshire<br>LOL B1Z')
    end
  end

  its(:telephone_number) { is_expected.to eq('01234567890') }
  its(:acas_early_conciliation_certificate_number) { is_expected.to eq('123') }
  its(:no_acas_number_reason) do
    is_expected.
      to eq("Acas doesn't have the power to conciliate on some or all of my claim")
  end
end
