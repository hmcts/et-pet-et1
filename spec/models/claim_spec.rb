require 'rails_helper'

RSpec.describe Claim, :type => :model do
  it { is_expected.to have_secure_password }

  it { is_expected.to have_many :claimants }
  it { is_expected.to have_many :respondents }

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

  describe 'bitmasked attributes' do
    %i<discrimination_claims pay_claims desired_outcomes>.each do |attr|
      specify { expect(subject.send attr).to be_an(Array) }
    end
  end

  describe '#alleges_discrimination_or_unfair_dismissal?' do
    context 'when there are no claims of discrimination or unfair dismissal' do
      its(:alleges_discrimination_or_unfair_dismissal?) { is_expected.to be false }
    end

    context 'when there is a claim of discrimination' do
      before { subject.discrimination_claims << :race }
      its(:alleges_discrimination_or_unfair_dismissal?) { is_expected.to be true }
    end

    context 'when there is a claim of unfair dismissal' do
      before { subject.is_unfair_dismissal = true }
      its(:alleges_discrimination_or_unfair_dismissal?) { is_expected.to be true }
    end

    context 'when there are claims of both discrimination and unfair dismissal' do
      before do
        subject.discrimination_claims << :race
        subject.is_unfair_dismissal = true
      end

      its(:alleges_discrimination_or_unfair_dismissal?) { is_expected.to be true }
    end
  end
end
