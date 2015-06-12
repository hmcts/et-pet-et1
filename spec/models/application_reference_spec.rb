require 'rails_helper'

RSpec.describe ApplicationReference, type: :model do
  subject { described_class.create }

  it { is_expected.to belong_to(:claim) }

  describe 'before creating' do
    it 'checks for collisions when generating a reference' do
      allow(described_class).to receive(:generate).
        and_return('AAAA-1111', 'BBBB-2222', 'CCCC-3333')
      2.times { described_class.create }

      expect(subject.reference).to eq 'CCCC-3333'
    end
  end

  describe '#reference' do
    it 'returns a generated token' do
      expect(described_class).to receive(:generate) { 'ABCD-1234' }
      expect(subject.reference).to eq 'ABCD-1234'
    end
  end

  describe '.generate' do
    it 'returns a hyphenated eight-character code' do
      expect(described_class.generate).to match(/\A[0-9A-Z]{4}-[0-9A-Z]{4}\z/)
    end

    it 'is always full length even if there are leading zero bytes' do
      allow(SecureRandom).to receive(:random_bytes) { "\x00\x00\x00\x00\xff" }
      expect(described_class.generate).to eql('0000-007Z')
    end

    it 'returns a distinct code each time' do
      codes = 100.times.map { described_class.generate }
      expect(codes.uniq.length).to eql(100)
    end

    it 'uses only digits and letters (except I, L, O, U)' do
      codes = 100.times.map { described_class.generate }.join
      expect(codes).to match(/\A[0-9A-HJKMNP-TV-Z\-]+\z/)
    end
  end

  describe '.normalize' do
    it 'adds a hyphen' do
      input    = '18C9QQW4'
      expected = '18C9-QQW4'
      expect(described_class.normalize(input)).to eql(expected)
    end

    it 'changes spaces' do
      input    = '18C9 QQW4'
      expected = '18C9-QQW4'
      expect(described_class.normalize(input)).to eql(expected)
    end

    it 'changes case' do
      input    = '18c9-qqw4'
      expected = '18C9-QQW4'
      expect(described_class.normalize(input)).to eql(expected)
    end

    it 'changes ambiguous letters I, L, O to 1, 1, 0' do
      input    = 'ILOi-loIL'
      expected = '1101-1011'
      expect(described_class.normalize(input)).to eql(expected)
    end

    it 'returns a string when given garbage' do
      input = ':-)'
      expect(described_class.normalize(input)).to be_kind_of(String)
    end
  end
end
