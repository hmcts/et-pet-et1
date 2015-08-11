require 'rails_helper'

RSpec.describe HealthcheckComponent::BarclaycardGateway, type: :service do

  it_behaves_like 'a healthcheck component'

  subject { described_class.new }

  context 'payment gateway is unavailable' do
    before { allow(PaymentGateway).to receive(:available?).and_return false }
    its(:available?) { is_expected.to be_falsey }
  end

  context 'payment gateway is available' do
    before { allow(PaymentGateway).to receive(:available?).and_return true }
    its(:available?) { is_expected.to be_truthy }
  end
end
