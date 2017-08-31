require 'rails_helper'

Thread.abort_on_exception = true

RSpec.describe PaymentGateway, type: :service do
  let(:payment_gateway) { PaymentGateway }

  describe '.available?' do
    around do |example|
      pdq_stub
      payment_gateway.run
      sleep 1 # Allow thread to start - we were getting flickering failures
      example.run
      payment_gateway.stop
      WebMock.reset_callbacks
    end

    context 'when the gateway returns HTTP error codes' do
      let(:pdq_stub) do
        stub_request(:get, ENV.fetch('PAYMENT_GATEWAY_PING_ENDPOINT')).to_return status: 500, body: ''
      end

      it 'returns false' do
        expect(payment_gateway.available?).to be false
      end
    end

    context 'when the gateway is down' do
      let(:pdq_stub) do
        stub_request(:get, ENV.fetch('PAYMENT_GATEWAY_PING_ENDPOINT')).to_raise(Errno::ECONNREFUSED)
      end

      it 'returns false' do
        expect(payment_gateway.available?).to be false
      end
    end

    context 'when the gateway is up' do
      let(:pdq_stub) do
        stub_request(:get, ENV.fetch('PAYMENT_GATEWAY_PING_ENDPOINT')).to_return status: 200, body: ''
      end

      it 'returns true' do
        expect(payment_gateway.available?).to be true
      end
    end
  end
end
