require 'rails_helper'

RSpec.describe AccessDetailsMailer, type: :service do

  describe '.deliver_later' do
    context 'when the claim has an email address' do

      let(:claim) { Claim.create email_address: "funky@emailaddress.com" }

      it 'delivers access details via email' do
        expect{ described_class.deliver_later(claim) }.
          to change{ ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context 'when the claim has no email address' do

      let(:claim) { Claim.new }

      it 'doesnt deliver access details via email' do
        expect{ described_class.deliver_later(claim) }.
          not_to change{ ActionMailer::Base.deliveries.count }
      end
    end
  end
end
