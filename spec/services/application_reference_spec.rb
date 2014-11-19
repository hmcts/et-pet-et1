RSpec.describe ApplicationReference do
  describe 'generate' do
    it 'returns a hyphenated eight-character code' do
      expect(described_class.generate).to match(/\A[0-9A-Z]{4}-[0-9A-Z]{4}\z/)
    end

    it 'returns longer codes if asked' do
      expect(described_class.generate(12)).
        to match(/\A[0-9A-Z]{4}-[0-9A-Z]{4}-[0-9A-Z]{4}\z/)
      expect(described_class.generate(10)).
        to match(/\A[0-9A-Z]{4}-[0-9A-Z]{4}-[0-9A-Z]{2}\z/)
    end

    it 'is always full length even if a short random number is returned' do
      allow(SecureRandom).to receive(:hex) { '000000000000000000000000000000ff' }
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

  describe 'normalize' do
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
