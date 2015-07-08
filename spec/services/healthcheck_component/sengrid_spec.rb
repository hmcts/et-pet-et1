require 'rails_helper'

RSpec.describe HealthcheckComponent::Sendgrid, type: :service do

  it_behaves_like 'a healthcheck component'

  let(:spoof_smtp_settings) do
    { address: 'emailz.example.biz', port: '587' }
  end

  before(:each) do
    allow(ActionMailer::Base).to receive(:smtp_settings).
      and_return(spoof_smtp_settings)
  end

  subject { described_class.new }

  context 'sengrid is available' do
    let(:successful_smtp_response) do
      instance_double Net::SMTP::Response, success?: true
    end

    before do
      allow(Net::SMTP).to receive(:start).
        with('emailz.example.biz', '587').
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
        with('emailz.example.biz', '587').
        and_return(failed_smtp_response)
    end

    its(:available?) { is_expected.to be_falsey }
  end
end
