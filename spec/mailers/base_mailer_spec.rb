require "rails_helper"

describe BaseMailer do
  let(:claim) { Claim.create }
  let(:email_address) { 'mail@example.com' }

  before do
    @mailer = BaseMailer.access_details_email(claim, email_address)
    @mailer.deliver
    @mail = ActionMailer::Base.deliveries.last
  end

  it "has a to address" do
    expect(@mail.to).to eq [email_address]
  end

  it "has reference in the subject" do
    expect(@mail.subject).to include claim.reference
  end

  it "has reference in body" do
    expect(@mail.body).to include claim.reference
  end
end
