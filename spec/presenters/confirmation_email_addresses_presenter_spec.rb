require 'rails_helper'

RSpec.describe ConfirmationEmailAddressesPresenter, type: :presenter do
  subject { described_class.email_addresses_for claim }

  let(:claimant_with_email)           { create :claimant, primary_claimant: true, email_address: 'such@lol.biz' }
  let(:representative_with_email)     { create :representative, email_address: 'edgar@lol.biz' }
  let(:claimant_without_email)        { create :claimant, primary_claimant: true, email_address: nil }
  let(:representative_without_email)  { create :representative, email_address: nil }

  describe '.for' do
    context 'only the primary claimant has an email' do
      let(:claim) do
        create :claim,
          primary_claimant: claimant_with_email, representative: representative_without_email
      end

      it 'returns one email with the check property set' do
        expect(subject).to eq [['such@lol.biz', { checked: true }]]
      end
    end

    context 'only the representative has an email' do
      let(:claim) do
        create :claim,
          primary_claimant: claimant_without_email, representative: representative_with_email
      end

      it 'returns one email with the check property set' do
        expect(subject).to eq [['edgar@lol.biz', { checked: true }]]
      end
    end

    context 'primary claimant & representative emails present' do
      let(:claim) do
        create :claim,
          primary_claimant: claimant_with_email, representative: representative_with_email
      end

      it 'returns two emails with checked properties set' do
        expect(subject).to eq [['such@lol.biz', { checked: true }], ['edgar@lol.biz', { checked: true }]]
      end
    end

    context 'multiple claimants & representative email present' do
      let(:claim) do
        create :claim, :with_secondary_claimants,
          primary_claimant: claimant_with_email, representative: representative_with_email
      end

      it 'returns two emails with only the representative checked property set' do
        expect(subject).to eq [['such@lol.biz', { checked: false }], ['edgar@lol.biz', { checked: true }]]
      end
    end

    context 'no emails have been provided' do
      let(:claim) do
        create :claim,
          primary_claimant: claimant_without_email, representative: representative_without_email
      end

      specify { expect(subject).to be_empty }
    end
  end
end
