require 'rails_helper'

RSpec.describe PasswordForm, :type => :form do
  describe 'validations' do
    it { is_expected.to_not validate_presence_of(:password) }
    it { is_expected.to     validate_confirmation_of(:password) }

    describe 'password_confirmation when password has changed' do
      before { subject.password = 'lol' }
      it { is_expected.to validate_presence_of(:password_confirmation) }
    end

    describe 'password_confirmation when password has not changed' do
      it { is_expected.to_not validate_presence_of(:password_confirmation) }
    end
  end
  
  describe '.model_name_i18n_key' do
    specify do
      expect(described_class.model_name_i18n_key).
        to eq(described_class.model_name.i18n_key)
    end
  end

  describe '#save' do
    let(:model) { double('model') }
    let(:attributes) { { password: 'lol', password_confirmation: 'lol' } }
    let(:subject) { PasswordForm.new(attributes).tap { |f| f.resource = model } }

    it 'calls update_attributes on the underlying model with its own attributes' do
      expect(model).to receive(:update_attributes).with attributes
      allow(model).to  receive(:save)
      subject.save
    end
  end
end
