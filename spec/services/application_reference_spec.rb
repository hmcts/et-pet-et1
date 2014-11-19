RSpec.describe ApplicationReference do
  it 'generates an eight-character code' do
    expect(described_class.generate.length).to eql(8)
  end

  it 'generates a distinct code each time' do
    codes = 100.times.map { described_class.generate }
    expect(codes.uniq.length).to eql(100)
  end

  it 'uses only digits and letters except I, L, O, U' do
    codes = 100.times.map { described_class.generate }.join
    expect(codes).to match(/\A[0-9A-HJKMNP-TV-Z']+\z/)
  end

  it 'normalises case of string' do
    input    = '18c9qqw447wnhw23a4xews6hhh'
    expected = '18C9QQW447WNHW23A4XEWS6HHH'
    expect(described_class.normalize(input)).to eql(expected)
  end

  it 'normalizes I, L, O to 1, 1, 0' do
    input    = 'ILOILOILOILOiloiloiloiloil'
    expected = '11011011011011011011011011'
    expect(described_class.normalize(input)).to eql(expected)
  end
end
