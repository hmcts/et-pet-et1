require 'rails_helper'

RSpec.describe RespondentPresenter, type: :presenter do
  subject { described_class.new respondent }

  let(:respondent) do
    Respondent.new name: 'Lol Corp', address_building: '1', address_street: 'Lol street',
                   address_locality: 'Lolzville', address_county: 'Lolzfordshire',
                   address_post_code: 'LOL B1Z', address_telephone_number: '01234567890',
                   acas_early_conciliation_certificate_number: '123',
                   no_acas_number_reason: :acas_has_no_jurisdiction
  end

  its(:name) { is_expected.to eq('Lol Corp') }

  describe '#address' do
    it 'concatenates all address properties with a <br /> tag' do
      expect(subject.address).
        to eq('1<br />Lol street<br />Lolzville<br />Lolzfordshire<br />LOL B1Z<br />')
    end
  end

  its(:telephone_number) { is_expected.to eq('01234567890') }

  describe '#acas_early_conciliation_certificate_number' do
    its(:acas_early_conciliation_certificate_number) do
      is_expected.to eq '123'
    end

    context 'when target.acas_number_reason is nil' do
      before { respondent.acas_early_conciliation_certificate_number = '' }

      its(:acas_early_conciliation_certificate_number) do
        is_expected.
          to eq("Acas doesn’t have the power to conciliate on some or all of my claim")
      end
    end
  end

  describe '#each_item' do
    context 'when worked at a different address' do
      before { respondent.worked_at_same_address = false }

      it 'includes work_address' do
        expect { |b| subject.each_item &b }.
          to yield_successive_args [:name, "Lol Corp"],
            [:address, "1<br />Lol street<br />Lolzville<br />Lolzfordshire<br />LOL B1Z<br />"],
            [:telephone_number, "01234567890"], [:acas_early_conciliation_certificate_number, "123"],
            [:work_address, ""]
      end
    end

    context 'when target is not blank' do
      before { respondent.worked_at_same_address = true }

      it 'does not include work_address' do
        expect { |b| subject.each_item &b }.to yield_successive_args [:name, "Lol Corp"],
          [:address, "1<br />Lol street<br />Lolzville<br />Lolzfordshire<br />LOL B1Z<br />"],
          [:telephone_number, "01234567890"], [:acas_early_conciliation_certificate_number, "123"]
      end
    end
  end
end
