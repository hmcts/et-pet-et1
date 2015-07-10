require 'rails_helper'

RSpec.describe HealthcheckComponent::Sendgrid, type: :service do

  it_behaves_like 'a healthcheck component'

  subject { described_class.new }

  context 'sengrid is available' do
    let(:successful_smtp_response) do
      instance_double Net::SMTP::Response, success?: true
    end

    before do
      allow(Net::SMTP).to receive(:start).
        with('localhost', 25).
        and_return(successful_smtp_response)
    end

    its(:available?) { is_expected.to be_truthy }
  end

  context 'sendgrid is unavailable' do
    let(:failed_smtp_response) do
      instance_double Net::SMTP::Response, success?: false
    end

    before do
      allow(Net::SMTP).to receive(:start).
        with('localhost', 25).
        and_return(failed_smtp_response)
    end

    its(:available?) { is_expected.to be_falsey }
  end
end
