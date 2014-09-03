require 'rails_helper'

Thread.abort_on_exception = true

RSpec.describe PaymentGatewayCheck, type: :thread do
  describe '.available?' do
    around(:example) do |example|
      pdq_stub
      subject.run
      example.run
      subject.stop
    end

    context 'when the gateway returns HTTP error codes' do
      let(:pdq_stub) do
        stub_request(:get, ENV.fetch('PAYMENT_GATEWAY_PING_ENDPOINT')).to_return status: 500, body: ''
      end

      it 'returns false' do
        expect(subject.available?).to be false
      end
    end

    context 'when the gateway is down' do
      let(:pdq_stub) do
        stub_request(:get, ENV.fetch('PAYMENT_GATEWAY_PING_ENDPOINT')).to_raise(Errno::ECONNREFUSED)
      end

      it 'returns false' do
        expect(subject.available?).to be false
      end
    end

    context 'when the gateway is up' do
      let(:pdq_stub) do
        stub_request(:get, ENV.fetch('PAYMENT_GATEWAY_PING_ENDPOINT')).to_return status: 200, body: ''
      end

      it 'returns true' do
        expect(subject.available?).to be true
      end
    end
  end
end
