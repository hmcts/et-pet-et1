require 'rails_helper'

RSpec.describe Healthcheck, type: :service do
  let(:components) do
    [
      { name: 'rabbit_mq', available: true },
      { name: 'barclaycard_gateway', available: true },
      { name: 'sendgrid', available: true }
    ]
  end

  let(:success_json) do
    { status: 'ok', components: components }
  end

  before do
    Rails.cache.clear
    allow(Healthcheck).to receive(:components).once.and_return components
  end

  after do
    Rails.cache.clear
  end

  context 'when healthcheck is cached' do
    before do
      Healthcheck.report # caches report
    end

    it "returns a cached healthcheck report" do
      expect(HealthcheckReport).not_to receive(:new)
      report = Healthcheck.report
      expect(report.report).to eq success_json
    end
  end

  context 'when healthcheck is not cached' do
    it "returns a new healthcheck report" do
      expect(HealthcheckReport).to receive(:new).with(components).once.and_return HealthcheckReport.new(components)
      report = Healthcheck.report
      expect(report.report).to eq success_json
    end
  end
end
