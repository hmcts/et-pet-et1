require 'rails_helper'

RSpec.describe HealthcheckComponent::Sendgrid, type: :service do

  subject { described_class.new }

  before do
    smtp_response = instance_double Net::SMTP::Response, success?: response_success
    smtp = instance_double('Net::SMTP', helo: smtp_response)

    allow(Net::SMTP).to receive(:start).
      with('localhost', 25).
      and_yield smtp
  end

  context 'sendgrid is available' do
    let(:response_success) { true }

    it_behaves_like 'a healthcheck component'

    its(:available?) { is_expected.to be_truthy }
  end

  context 'sendgrid is unavailable' do
    let(:response_success) { false }

    it_behaves_like 'a healthcheck component'

    its(:available?) { is_expected.to be_falsey }
  end
end
