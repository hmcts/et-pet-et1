require 'rails_helper'

RSpec.describe MemorableWordForm, type: :form do

  describe 'validations' do
    context 'presence' do
      it { is_expected.to validate_presence_of(:password) }
    end
  end

  describe '#save' do
    context "when save on the superclass is successful" do
      subject { described_class.new password: "supersecure" }

      it "attempts to deliver access details via email" do
        expect(AccessDetailsMailer).to receive(:deliver_later)
        subject.save
      end

      it "returns true allowing save to perform like an AR model" do
        expect(subject.save).to be_truthy
      end
    end

    context "when save on the superclass is unsuccessful" do
      subject { described_class.new }

      it "doesn't deliver access details via email" do
        expect(AccessDetailsMailer).to_not receive(:deliver_later)
        subject.save
      end

      it "returns false" do
        expect(subject.save).to be_falsey
      end
    end
  end

  attributes = { password: "mypassword", email_address: "such@emailaddress.com" }

  set_resource = proc do form.resource = target end

  it_behaves_like("a Form", attributes, set_resource)

end