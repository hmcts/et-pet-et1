require 'rails_helper'

RSpec.describe PdfForm::BaseDelegator, type: :presenter do
  subject { described_class.new(nil) }

  describe '#format_postcode' do
    it 'returns padded postcodes' do
      expect(subject.format_postcode('W1A 1HQ')).to eq('W1A 1HQ')
      expect(subject.format_postcode('M1 1AA')).to eq('M1  1AA')
      expect(subject.format_postcode('DN55 1PT')).to eq('DN551PT')
      expect(subject.format_postcode('A99AA')).to eq('A9  9AA')
    end
  end

  describe '#use_of_off' do
    it 'returns field when set' do
      result = subject.use_or_off('option', ['option'])
      expect(result).to eq('option')
    end

    it 'returns Off when not set' do
      result = subject.use_or_off(nil, ['option'])
      expect(result).to eq('Off')
    end
  end

  describe '#tri_state' do
    it 'returns Off when nil' do
      expect(subject.tri_state(nil)).to eq('Off')
    end

    it 'returns no when false' do
      expect(subject.tri_state(false)).to eq('no')
    end

    it 'returns yes when true' do
      expect(subject.tri_state(true)).to eq('yes')
    end

    it 'returns value for yes when true and passed value' do
      expect(subject.tri_state(true, yes: 'Yes')).to eq('Yes')
    end
  end

  describe '#dual_state' do
    it 'returns Off when nil' do
      expect(subject.dual_state(nil)).to eq('Off')
    end

    it 'returns Off when false' do
      expect(subject.dual_state(false)).to eq('Off')
    end

    it 'returns yes when true' do
      expect(subject.dual_state(true)).to eq('yes')
    end

    it 'returns value for yes when true and passed value' do
      expect(subject.dual_state(true, yes: 'Yes')).to eq('Yes')
    end
  end

  describe '#format_date' do
    it 'returns a date in the format DD/MM/YYYY' do
      travel_to(Date.new 2014, 9, 29) do
        expect(subject.format_date(Time.now)).to eq "29/09/2014"
      end
    end
  end
end
