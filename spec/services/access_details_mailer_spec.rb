require 'rails_helper'

RSpec.describe AccessDetailsMailer, type: :service do
  include ActiveJob::TestHelper

  describe '.deliver_later' do
    context 'when the claim has an email address' do

      let(:claim) { Claim.create email_address: "funky@emailaddress.com" }

      it 'delivers access details via email' do
        described_class.deliver_later(claim)
        job_spec = queue_adapter.enqueued_jobs.select { |job_spec| job_spec[:job] == ActionMailer::DeliveryJob }.last

        expect { job_spec[:job].perform_now(*job_spec[:args]) }.
          to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end

    context 'when the claim has no email address' do

      let(:claim) { Claim.new }

      it 'doesnt deliver access details via email' do
        described_class.deliver_later(claim)
        expect(ActionMailer::DeliveryJob).not_to have_been_enqueued
      end
    end
  end
end
