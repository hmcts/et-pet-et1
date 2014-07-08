require 'rails_helper'

RSpec.describe PasswordForm, :type => :form do
  describe '#save' do
    let(:model) { double('model') }
    let(:attributes) { { password: 'lol', password_confirmation: 'lol' } }
    let(:subject) { PasswordForm.new(attributes).tap { |f| f.resource = model } }

    it 'calls update_attributes on the underlying model with its own attributes' do
      expect(model).to receive(:update_attributes).with attributes
      subject.save
    end
  end
end
