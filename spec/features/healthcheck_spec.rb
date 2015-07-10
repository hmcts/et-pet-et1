require 'rails_helper'

RSpec.feature 'viewing the applicatons healthcheck', type: :feature do

  let(:json) { page.body }
  let(:status_code) { page.status_code }

  before(:each) do
    allow(HealthcheckComponent::RabbitMq).to receive(:available?).and_return(true)
    allow(HealthcheckComponent::BarclaycardGateway).to receive(:available?).and_return(true)
    allow(HealthcheckComponent::Sendgrid).to receive(:available?).and_return(true)
  end

  context 'when the application is in good health' do
    before { visit healthcheck_path }

    let(:successful_json) do
      {
        status: 'ok',
        components: [
          { name: 'rabbit_mq', available: true },
          { name: 'barclaycard_gateway', available: true },
          { name: 'sendgrid', available: true }
        ]
      }.to_json
    end

    it "returns a json response with an 'ok' status" do
      expect(json).to eq successful_json
    end

    it 'returns a 200 http status code' do
      expect(status_code).to eq 200
    end
  end

  context 'when the application is in poor health' do
    let(:failed_json) { { status: 'bad', components: failed_components }.to_json }

    context 'rabbit mq is unavailable' do
      before do
        allow(HealthcheckComponent::RabbitMq).to receive(:available?).and_return(false)
        visit healthcheck_path
      end

      let(:failed_components) do
        [{ name: 'rabbit_mq', available: false },
          { name: 'barclaycard_gateway', available: true },
          { name: 'sendgrid', available: true }]
      end

      it "returns a json response with a 'bad' status" do
        expect(json).to eq failed_json
      end

      it 'returns a 500 http status code' do
        expect(status_code).to eq 500
      end
    end

    context 'sengrid is unavailable' do
      before do
        allow(HealthcheckComponent::Sendgrid).to receive(:available?).and_return(false)
        visit healthcheck_path
      end

      let(:failed_components) do
        [{ name: 'rabbit_mq', available: true },
          { name: 'barclaycard_gateway', available: true },
          { name: 'sendgrid', available: false }]
      end

      it "returns a json response with a 'bad' status" do
        expect(json).to eq failed_json
      end

      it 'returns a 500 http status code' do
        expect(status_code).to eq 500
      end

    end

    context 'the payment gateway is unavailable' do
      before do
        allow(HealthcheckComponent::BarclaycardGateway).to receive(:available?).and_return(false)
        visit healthcheck_path
      end

      let(:failed_components) do
        [{ name: 'rabbit_mq', available: true },
          { name: 'barclaycard_gateway', available: false },
          { name: 'sendgrid', available: true }]
      end

      it "returns a json response with a 'bad' status" do
        expect(json).to eq failed_json
      end

      it 'returns a 500 http status code' do
        expect(status_code).to eq 500
      end
    end
  end
end
