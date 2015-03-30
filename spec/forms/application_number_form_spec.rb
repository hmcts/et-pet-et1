require 'rails_helper'

RSpec.describe ApplicationNumberForm, type: :form do
  subject { described_class.new(Claim.new) }

  describe 'validations' do
    context 'presence' do
      it { is_expected.to validate_presence_of(:password) }
    end
    context 'no_email' do
      it { is_expected.not_to validate_presence_of(:email_address) }
    end

    include_examples "Email validation",
      error_message: 'You have entered an invalid email address'
  end

  describe '#save' do
    context "if successful it runs callbacks" do
      before { subject.password = "supersecure" }
      before { subject.email_address = "" }

      it "attempts to deliver access details via email" do
        expect(AccessDetailsMailer).to receive(:deliver_later)
        subject.save
      end
    end

    context "if unsuccessful it doesnt run callbacks" do
      it "doesn't deliver access details via email" do
        expect(AccessDetailsMailer).to_not receive(:deliver_later)
        subject.save
      end
    end
  end

  it_behaves_like "a Form", password: "mypassword", email_address: "such@emailaddress.com"
end
