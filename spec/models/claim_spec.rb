require 'rails_helper'

RSpec.describe Claim, :type => :model do
  it { is_expected.to have_secure_password }

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

  describe '#reference' do
    let(:claim) { Claim.new id: 1 }

    it 'returns a token based upon the primary key' do
      expect(claim.reference).to eq('6CWKCC9P70W38C1K')
    end
  end
end
