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

  describe '#remission_claimant_count' do
    let (:query) { double }

    before do
      allow(claim.claimants).to receive(:where).
        with(applying_for_remission: true).
        and_return query
    end

    it 'delegates to the claimant association proxy' do
      expect(query).to receive(:count)

      claim.remission_claimant_count
    end
  end

  describe '#alleges_discrimination_or_unfair_dismissal?' do
    it 'is delegated to the claim_detail association proxy' do
      expect(subject.claim_detail).to receive(:alleges_discrimination_or_unfair_dismissal?)

      claim.alleges_discrimination_or_unfair_dismissal?
    end
  end
end
