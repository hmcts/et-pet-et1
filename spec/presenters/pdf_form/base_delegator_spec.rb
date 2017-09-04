require 'rails_helper'

RSpec.describe PdfForm::BaseDelegator, type: :presenter do
  let(:pdf_form_base_delagator) { described_class.new(nil) }

  describe '#format_postcode' do
    context 'for valid UK postcodes' do
      describe 'returns padded, formatted postcodes' do
        it { expect(pdf_form_base_delagator.format_postcode('w1a 1hq')).to eq('W1A 1HQ') }
        it { expect(pdf_form_base_delagator.format_postcode('m1 1aa')).to eq('M1  1AA') }
        it { expect(pdf_form_base_delagator.format_postcode('dn551pt')).to eq('DN551PT') }
        it { expect(pdf_form_base_delagator.format_postcode('a99aa')).to eq('A9  9AA') }
      end
    end

    context 'for invalid uk postcodes, i.e. international postcodes' do
      it 'does not format the result' do
        expect(pdf_form_base_delagator.format_postcode('123 45')).to eq('123 45')
      end
    end

    context 'for nil' do
      it 'returns an empty string' do
        expect(pdf_form_base_delagator.format_postcode(nil)).to eq('')
      end
    end
  end

  describe '#use_of_off' do
    it 'returns field when set' do
      result = pdf_form_base_delagator.use_or_off('option', ['option'])
      expect(result).to eq('option')
    end

    it 'returns Off when not set' do
      result = pdf_form_base_delagator.use_or_off(nil, ['option'])
      expect(result).to eq('Off')
    end
  end

  describe '#tri_state' do
    it 'returns Off when nil' do
      expect(pdf_form_base_delagator.tri_state(nil)).to eq('Off')
    end

    it 'returns no when false' do
      expect(pdf_form_base_delagator.tri_state(false)).to eq('no')
    end

    it 'returns yes when true' do
      expect(pdf_form_base_delagator.tri_state(true)).to eq('yes')
    end

    it 'returns value for yes when true and passed value' do
      expect(pdf_form_base_delagator.tri_state(true, yes: 'Yes')).to eq('Yes')
    end
  end

  describe '#dual_state' do
    it 'returns Off when nil' do
      expect(pdf_form_base_delagator.dual_state(nil)).to eq('Off')
    end

    it 'returns Off when false' do
      expect(pdf_form_base_delagator.dual_state(false)).to eq('Off')
    end

    it 'returns yes when true' do
      expect(pdf_form_base_delagator.dual_state(true)).to eq('yes')
    end

    it 'returns value for yes when true and passed value' do
      expect(pdf_form_base_delagator.dual_state(true, yes: 'Yes')).to eq('Yes')
    end
  end

  describe '#format_date' do
    it 'returns a date in the format DD/MM/YYYY' do
      travel_to(DateTime.new(2014, 9, 29, 0, 0, 0).utc) do
        expect(pdf_form_base_delagator.format_date(Time.current)).to eq "29/09/2014"
      end
    end
  end
end
