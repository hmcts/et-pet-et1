require 'rails_helper'

RSpec.describe Multipart::StringParam, type: :service do
  it 'renders with a header and the content' do
    param = described_class.new('NAME', 'CONTENT')
    expected = %{Content-Disposition: form-data; name="NAME"\r\n\r\nCONTENT}
    expect(param.to_multipart).to eql(expected)
  end
end

RSpec.describe Multipart::FileParam, type: :service do
  it 'renders with two headers and the content' do
    param = described_class.new('NAME', 'FILENAME', 'CONTENT')
    expected = %{Content-Disposition: form-data; name="NAME"; filename="FILENAME"\r\nContent-Type: application/octet-stream\r\n\r\nCONTENT}
    expect(param.to_multipart).to eql(expected)
  end
end

RSpec.describe Multipart::Post, type: :service do
  subject {
    described_class.new(
      '/foo',
      Multipart::StringParam.new('string', 'AAA'),
      Multipart::FileParam.new('file', 'filename', 'BBB')
    )
  }

  before do
    allow(SecureRandom).to receive(:hex) { "0123456789abcdefdeadbeefcafeface" }.once
  end

  it 'includes all parameters in the body, separated by boundary' do
    expected = %{--0123456789abcdefdeadbeefcafeface\r\nContent-Disposition: form-data; name="string"\r\n\r\nAAA\r\n--0123456789abcdefdeadbeefcafeface\r\nContent-Disposition: form-data; name="file"; filename="filename"\r\nContent-Type: application/octet-stream\r\n\r\nBBB\r\n--0123456789abcdefdeadbeefcafeface--\r\n}
    expect(subject.body).to eql(expected)
  end

  it 'includes the boundary in the header' do
    expected = 'multipart/form-data; boundary=0123456789abcdefdeadbeefcafeface'
    expect(subject['Content-Type']).to eql(expected)
  end

  it 'is a Net::HTTP::Post' do
    expect(subject).to be_kind_of(Net::HTTP::Post)
  end
end
