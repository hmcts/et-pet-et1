require 'rails_helper'

RSpec.describe Jadu::APIRequest do
  let(:uri) { URI.parse('https://example.com/api') }
  let(:post) { double(:post).tap { |p| allow(p).to receive(:[]=) } }

  it 'sets the Host header if supplied' do
    allow(Multipart::Post).to receive(:new) { post }
    allow(Net::HTTP).to receive(:start)

    expect(post).to receive(:[]=).with('Host', 'foobar.example.com')
    described_class.new(uri, [], host: 'foobar.example.com').do
  end

  it 'sets the Host to the URI host if not otherwise set' do
    allow(Multipart::Post).to receive(:new) { post }
    allow(Net::HTTP).to receive(:start)

    expect(post).to receive(:[]=).with('Host', 'example.com')
    described_class.new(uri, []).do
  end

  it 'initialises Multipart::Post with the supplied parameters' do
    param_a = double(:param_a)
    param_b = double(:param_b)
    allow(Net::HTTP).to receive(:start)

    expect(Multipart::Post).to receive(:new).
      with('/api', param_a, param_b) { post }
    described_class.new(uri, [param_a, param_b]).do
  end

  it 'uses SSL' do
    expect(Net::HTTP).to receive(:start).
      with(anything, anything, hash_including(use_ssl: true))
    described_class.new(uri, []).do
  end

  it 'passes arbitrary options to Net::HTTP.start' do
    expect(Net::HTTP).to receive(:start).
      with(anything, anything, hash_including(foo: 'a', bar: 'b'))
    described_class.new(uri, [], foo: 'a', bar: 'b').do
  end

  it 'returns the response object' do
    response = double(:response)
    allow(Net::HTTP).to receive(:start) { response }

    expect(described_class.new(uri, []).do).to eql(response)
  end

  it 'sends a POST request' do
    http = double(:http)
    allow(Multipart::Post).to receive(:new) { post }
    allow(Net::HTTP).to receive(:start).and_yield(http)

    expect(http).to receive(:request).with(post)
    described_class.new(uri, []).do
  end
end

RSpec.describe Jadu::ETOffice do
  let(:uri) { URI.parse('https://example.com/api') }

  it 'constructs a request with URI, options, and a postcode field' do
    expect(Jadu::APIRequest).to receive(:new).
      with(uri, [Multipart::StringParam.new('postcode', 'SW1A 1AA')], foo: 'bar')
    described_class.new(uri, 'SW1A 1AA', foo: 'bar')
  end

  it 'forwards :do to the API request' do
    api_request = double(:api_request)
    allow(Jadu::APIRequest).to receive(:new) { api_request }

    expect(api_request).to receive(:do)
    described_class.new(uri, 'SW1A 1AA').do
  end
end

RSpec.describe Jadu::NewClaim do
  let(:uri) { URI.parse('https://example.com/api') }
  let(:xml) { '<xml />' }

  it 'constructs a request with URI, fields, and options' do
    params = [
      Multipart::StringParam.new('new_claim', xml),
      Multipart::FileParam.new('example.pdf', 'example.pdf', 'AAA')
    ]

    expect(Jadu::APIRequest).to receive(:new).with(uri, params, foo: 'bar')
    described_class.new(uri, xml, { 'example.pdf' => 'AAA' }, foo: 'bar')
  end

  it 'forwards :do to the API request' do
    api_request = double(:api_request)
    allow(Jadu::APIRequest).to receive(:new) { api_request }

    expect(api_request).to receive(:do)
    described_class.new(uri, xml, {}).do
  end
end

RSpec.describe Jadu::API do
  subject { described_class.new(base_url, ssl_version: :TLSv1) }
  let(:base_url) { 'https://example.com/api/1/' }
  let(:response) { double(:response) }

  it 'constructs and sends an ET Office request' do
    eto = double(:et_office)
    uri = URI.parse('https://example.com/api/1/fgr-et-office')
    postcode = 'SW1A 1AA'

    expect(Jadu::ETOffice).to receive(:new).
      with(uri, postcode, ssl_version: :TLSv1) { eto }
    expect(eto).to receive(:do) { response }

    expect(subject.fgr_et_office(postcode)).to eql(response)
  end

  it 'constructs and sends a New Claim request' do
    claim = double(:new_claim)
    uri = URI.parse('https://example.com/api/1/new-claim')
    xml = '<xml />'

    expect(Jadu::NewClaim).to receive(:new).
      with(uri, xml, { 'example.pdf' => 'PDF' }, ssl_version: :TLSv1) { claim }
    expect(claim).to receive(:do) { response }

    expect(subject.new_claim(xml, 'example.pdf' => 'PDF')).to eql(response)
  end
end
