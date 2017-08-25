require 'rails_helper'

RSpec.describe ApplicationNumberForm, type: :form do
  let(:application_number_form) { described_class.new(Claim.new) }

  describe 'validations' do
    context 'presence' do
      it { expect(application_number_form).to validate_presence_of(:password) }
    end

    context 'no_email' do
      it { expect(application_number_form).not_to validate_presence_of(:email_address) }
    end
  end

  describe '#save' do
    context "if successful it runs callbacks" do
      before do
        application_number_form.password = "supersecure"
        application_number_form.email_address = ""
      end

      it "attempts to deliver access details via email" do
        expect(AccessDetailsMailer).to receive(:deliver_later)
        application_number_form.save
      end
    end

    context "if unsuccessful it doesnt run callbacks" do
      it "doesn't deliver access details via email" do
        expect(AccessDetailsMailer).not_to receive(:deliver_later)
        application_number_form.save
      end
    end
  end

  it_behaves_like "a Form", password: "mypassword", email_address: "such@emailaddress.com"

  context 'shared validation' do
    subject { application_number_form }

    include_examples "Email validation",
      error_message: 'You have entered an invalid email address'
  end
end
