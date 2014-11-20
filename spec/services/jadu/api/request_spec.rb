require 'rails_helper'

RSpec.describe Jadu::API::Request do
  let(:uri) { URI.parse('https://example.com/api') }
  let(:post) { double(:post).tap { |p| allow(p).to receive(:[]=) } }

  it 'sets the Host header if supplied' do
    allow(Multipart::Post).to receive(:new) { post }
    allow(Net::HTTP).to receive(:start)

    expect(post).to receive(:[]=).with('Host', 'foobar.example.com')
    described_class.new(uri, [], host: 'foobar.example.com').perform
  end

  it 'sets the Host to the URI host if not otherwise set' do
    allow(Multipart::Post).to receive(:new) { post }
    allow(Net::HTTP).to receive(:start)

    expect(post).to receive(:[]=).with('Host', 'example.com')
    described_class.new(uri, []).perform
  end

  it 'initialises Multipart::Post with the supplied parameters' do
    param_a = double(:param_a)
    param_b = double(:param_b)
    allow(Net::HTTP).to receive(:start)

    expect(Multipart::Post).to receive(:new).
      with('/api', param_a, param_b) { post }
    described_class.new(uri, [param_a, param_b]).perform
  end

  it 'uses SSL' do
    expect(Net::HTTP).to receive(:start).
      with(anything, anything, hash_including(use_ssl: true))
    described_class.new(uri, []).perform
  end

  it 'passes arbitrary options to Net::HTTP.start' do
    expect(Net::HTTP).to receive(:start).
      with(anything, anything, hash_including(foo: 'a', bar: 'b'))
    described_class.new(uri, [], foo: 'a', bar: 'b').perform
  end

  it 'returns the response object' do
    response = double(:response)
    allow(Net::HTTP).to receive(:start) { response }

    expect(described_class.new(uri, []).perform).to eql(response)
  end

  it 'sends a POST request' do
    http = double(:http)
    allow(Multipart::Post).to receive(:new) { post }
    allow(Net::HTTP).to receive(:start).and_yield(http)

    expect(http).to receive(:request).with(post)
    described_class.new(uri, []).perform
  end
end
