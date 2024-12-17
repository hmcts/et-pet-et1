require 'rails_helper'

RSpec.describe Multipart, type: :service do
  context 'with StringParam' do
    it 'renders with a header and the content' do
      param = Multipart::StringParam.new('NAME', 'CONTENT')
      expected = %(Content-Disposition: form-data; name="NAME"\r\n\r\nCONTENT)
      expect(param.to_multipart).to eql(expected)
    end
  end

  context 'with FileParam' do
    it 'renders with two headers and the content' do
      param = Multipart::FileParam.new('NAME', 'FILENAME', 'CONTENT')
      expected = %(Content-Disposition: form-data; name="NAME"; filename="FILENAME"\r\nContent-Type: application/octet-stream\r\n\r\nCONTENT)
      expect(param.to_multipart).to eql(expected)
    end
  end

  context 'when post' do
    let(:multipart_post) {
      Multipart::Post.new(
        '/foo',
        Multipart::StringParam.new('string', 'AAA'),
        Multipart::FileParam.new('file', 'filename', 'BBB')
      )
    }

    before do
      allow(SecureRandom).to receive(:hex).and_return("0123456789abcdefdeadbeefcafeface").once
    end

    it 'includes all parameters in the body, separated by boundary' do
      expected = %(--0123456789abcdefdeadbeefcafeface\r\nContent-Disposition: form-data; name="string"\r\n\r\nAAA\r\n--0123456789abcdefdeadbeefcafeface\r\nContent-Disposition: form-data; name="file"; filename="filename"\r\nContent-Type: application/octet-stream\r\n\r\nBBB\r\n--0123456789abcdefdeadbeefcafeface--\r\n)
      expect(multipart_post.body).to eql(expected)
    end

    it 'includes the boundary in the header' do
      expected = 'multipart/form-data; boundary=0123456789abcdefdeadbeefcafeface'
      expect(multipart_post['Content-Type']).to eql(expected)
    end

    it 'is a Net::HTTP::Post' do
      expect(multipart_post).to be_a(Net::HTTP::Post)
    end
  end
end
