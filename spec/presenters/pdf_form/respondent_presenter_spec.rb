require 'rails_helper'

RSpec.describe PdfForm::RespondentPresenter, type: :presenter do
  subject { described_class.new(respondent, index) }
  let(:hash) { subject.to_h }

  describe '#to_h' do
    let(:respondent) { Respondent.new(
      name: 'Clide and Son',
      work_address_post_code: 'A9 9AA',
      acas_early_conciliation_certificate_number: acas_number,
      no_acas_number_reason: acas_exemption)
    }
    let(:acas_number) { nil }
    let(:acas_exemption) { nil }

    context 'first respondent' do
      let(:index) { 0 }

      it 'includes correct name field' do
        expect(hash).to include('2.1' => 'Clide and Son')
      end

      it 'includes work_address' do
        expect(hash).to include('2.3 postcode' => 'A9  9AA')
      end

      context 'entered Acas number' do
        let(:acas_number) { '123' }

        it 'includes an Acas number' do
          expect(hash).to include('Text2' => acas_number)
          expect(hash).to include('Check Box1' => 'Yes')
        end
      end

      context 'did not enter Acas number' do
        let(:acas_number) { nil }

        it 'does not include an Acas number' do
          expect(hash).to include('Text2' => acas_number)
          expect(hash).to include('Check Box1' => 'no')
        end
      end

      context 'selected Acas exemption reason' do
        let(:acas_exemption) { 'interim_relief' }

        it 'checks correct check box' do
          expect(hash).not_to include('Check Box3', 'Check Box4', 'Check Box5', 'Check Box7')
          expect(hash).to include('Check Box6' => 'Yes')
        end
      end

      context 'did not select an Acas exemption reason' do
        let(:acas_exemption) { nil }

        it 'has no checkboxes selected' do
          expect(hash).not_to include('Check Box3', 'Check Box4', 'Check Box5', 'Check Box6', 'Check Box7')
        end
      end

      context 'has an unknown Acas reason' do
        let(:acas_exemption) { 'claim_against_security_services' }

        it 'has no checkboxes selected' do
          expect(hash).not_to include('Check Box3', 'Check Box4', 'Check Box5', 'Check Box6', 'Check Box7')
        end
      end
    end

    context 'second respondent' do
      let(:index) { 1 }

      it 'includes correct name field' do
        expect(hash).to include('2.4 R2 name' => 'Clide and Son')
      end

      it 'does not include work_address' do
        expect(hash).not_to include('2.3 postcode')
      end
    end
  end
end
