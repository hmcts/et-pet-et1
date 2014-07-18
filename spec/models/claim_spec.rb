require 'rails_helper'

RSpec.describe Claim, :type => :model do
  it { is_expected.to have_secure_password }

  it { is_expected.to have_many :claimants }
  it { is_expected.to have_many :respondents }
  it { is_expected.to have_one  :claim_detail }

  let(:claim) { Claim.new id: 1 }

  describe '#reference' do
    it 'returns a token based upon the primary key' do
      expect(claim.reference).to eq('6CWKCC9P70W38C1K')
    end
  end

  describe '#claimant_count' do
    it 'delegates to the claimant association proxy' do
      expect(claim.claimants).to receive(:count)

      claim.claimant_count
    end
  end
end
