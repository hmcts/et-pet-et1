# coding: utf-8
require "rails_helper"

describe BaseMailer, type: :mailer do
  include ClaimsHelper
  include Messages
  include MailMatchers

  let(:claim) { create(:claim, email_address: email_address) }
  let(:email_address) { 'mail@example.com' }
  let(:email) { subject.deliver_now }

  describe '#access_details_email' do
    subject { described_class.access_details_email(claim) }

    it 'has been delivered' do
      email
      expect(ActionMailer::Base.deliveries).to be_present
    end

    it 'has a recipient' do
      expect(email.to).to eq [email_address]
    end

    it "has a subject" do
      expect(email.subject).to eq "Employment tribunal: complete your claim"
    end

    it 'has reference in body' do
      expect(email).to match_pattern claim.reference
    end
  end
end
