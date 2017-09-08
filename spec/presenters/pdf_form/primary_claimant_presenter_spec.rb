require 'rails_helper'

RSpec.describe PdfForm::PrimaryClaimantPresenter, type: :presenter do
  let(:pdf_form_primary_claimant_presenter) { described_class.new(claimant) }

  let(:hash) { pdf_form_primary_claimant_presenter.to_h }

  describe '#name' do
    let(:claimant) { Claimant.new first_name: 'First', last_name: 'Last' }

    it 'returns first name, last name' do
      expect(pdf_form_primary_claimant_presenter.name).to eq('First Last')
    end
  end

  describe '#to_h' do
    it_behaves_like 'it includes a formatted postcode', Claimant, '1.5'
    it_behaves_like 'it includes a contact preference', Claimant, '1.8'

    context 'when date of birth' do
      let(:claimant) { Claimant.new date_of_birth: '1980-02-01' }

      describe 'includes date of birth fields' do
        it { expect(hash).to include('1.4 DOB day' => '01') }
        it { expect(hash).to include('1.4 DOB month' => '02') }
        it { expect(hash).to include('1.4 DOB year' => '1980') }
      end
    end

    context 'when no date of birth' do
      let(:claimant) { Claimant.new }

      describe 'includes date of birth fields' do
        it { expect(hash).to include('1.4 DOB day' => nil) }
        it { expect(hash).to include('1.4 DOB month' => nil) }
        it { expect(hash).to include('1.4 DOB year' => nil) }
      end
    end

    context 'when male gender specified' do
      let(:claimant) { Claimant.new gender: 'male' }

      it 'includes gender' do
        expect(hash).to include('1.4 gender' => 'male')
      end
    end

    context 'when female gender specified' do
      let(:claimant) { Claimant.new gender: 'female' }

      it 'includes gender' do
        expect(hash).to include('1.4 gender' => 'female')
      end
    end

    context 'when no gender specified' do
      let(:claimant) { Claimant.new gender: '' }

      it 'includes gender' do
        expect(hash).to include('1.4 gender' => 'Off')
      end
    end
  end
end
