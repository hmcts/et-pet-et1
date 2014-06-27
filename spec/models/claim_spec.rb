require 'rails_helper'

RSpec.describe Claim, :type => :model do
  it { is_expected.to have_secure_password }

  it { is_expected.to have_many :claimants }
  it { is_expected.to have_many :respondents }

  describe '#reference' do
    let(:claim) { Claim.new id: 1 }

    it 'returns a token based upon the primary key' do
      expect(claim.reference).to eq('6CWKCC9P70W38C1K')
    end
  end
end
