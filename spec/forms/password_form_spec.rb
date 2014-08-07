require 'rails_helper'

RSpec.describe PasswordForm, :type => :form do
  let(:model) { double('model') }
  let(:attributes) { { password: 'lol' } }
  subject { PasswordForm.new(attributes).tap { |f| f.resource = model } }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:password) }
  end

  describe '.model_name_i18n_key' do
    specify do
      expect(described_class.model_name_i18n_key).
        to eq(described_class.model_name.i18n_key)
    end
  end

  describe '#save' do
    it 'calls update_attributes on the underlying model with its own attributes' do
      allow(model).to receive(:update_attributes).with(attributes)
      allow(model).to receive(:save)

      subject.save
    end
  end

  describe "#mail_access_details" do
    context "when no save and return email specified" do
      it "does not send email" do
        expect(BaseMailer).not_to receive(:access_details_email)
        subject.mail_access_details
      end
    end

    context "when save and return email specified" do
      let(:email_address) { 'email address' }
      it "sends an email" do
        subject.save_and_return_email = email_address
        mock_mailer = double(:mailer)
        expect(mock_mailer).to receive(:deliver)
        expect(BaseMailer).to receive(:access_details_email).with(model, email_address).and_return(mock_mailer)
        subject.mail_access_details
      end
    end
  end
end
