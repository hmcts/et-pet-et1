require 'rails_helper'

RSpec.describe KeyObfuscator, type: :service do
  subject do
    described_class.new(secret: 'very.secret.such.confidential.wow.lol.biz.info')
  end

  describe '#obfuscate' do
    it 'returns an obfuscated representation of the input in the format 3-4' do
      expect(subject.obfuscate(1)).to eq('1BQ-HMCM')
    end

    it 'adds leading zeros to make seven characters' do
      expect(subject.obfuscate(4285926522)).to eq("02Z-PPNV")
    end
  end

  describe '#unobfuscate' do
    it 'returns the input unobfuscated' do
      expect(subject.unobfuscate('1BQ-HMCM')).to eq(1)
    end

    it 'ignores a missing hyphen' do
      expect(subject.unobfuscate('1BQHMCM')).to eq(1)
    end

    it 'ignores extra spaces' do
      expect(subject.unobfuscate('1BQ HMCM')).to eq(1)
    end

    it 'interprets ambiguous characters' do
      expect(subject.unobfuscate('LBQ-HMCM')).to eq(1)
      expect(subject.unobfuscate('IBQ-HMCM')).to eq(1)
      expect(subject.unobfuscate('O2Z-PPNV')).to eq(4285926522)
    end

    it 'is case-insensitive' do
      expect(subject.unobfuscate('1bq hmcm')).to eq(1)
    end
  end
end
