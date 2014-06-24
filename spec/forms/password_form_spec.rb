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
end
