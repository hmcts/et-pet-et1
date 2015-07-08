require 'rails_helper'

RSpec.describe HealthcheckComponent::RabbitMq, type: :service do

  it_behaves_like 'a healthcheck component'

  subject { described_class.new }

  context 'rabbit mq is unavaiable' do
    let(:failing_session) { instance_double Bunny::Session, connected?: false }

    before do
      allow(Bunny).to receive(:new).and_return failing_session
      allow(failing_session).to receive(:start)
      allow(failing_session).to receive(:close)
    end

    its(:available?) { is_expected.to be_falsey }
  end

  context 'rabbit mq is available' do
    let(:successful_session) { instance_double Bunny::Session, connected?: true }

    before do
      allow(Bunny).to receive(:new).and_return successful_session
      allow(successful_session).to receive(:start)
      allow(successful_session).to receive(:close)
    end

    its(:available?) { is_expected.to be_truthy }
  end
end
