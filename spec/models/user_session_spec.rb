require 'rails_helper'

describe UserSession do
  let(:claim) { double 'claim' }
  let(:reference) { 'reference' }
  let(:password) { 'password' }

  before do
    subject.reference = reference
    subject.password = password
    allow(Claim).to receive(:find_by_reference).with(reference).and_return claim
    allow(claim).to receive(:authenticate).with(password).and_return true
  end

  describe '#claim' do
    it 'finds the claim from the reference' do
      expect(subject.claim).to eq(claim)
    end
  end

  describe '#authenticates' do
    it 'does not add any errors when authentication successful' do
      expect(subject.save).to eq(true)
      expect(subject.errors).to be_empty
    end

    context 'when invalid reference' do
      before do
        allow(Claim).to receive(:find_by_reference).and_return nil
      end

      it 'adds error' do
        expect(subject.save).to eq(false)
        expect(subject.errors[:reference]).to include I18n.t('errors.user_session.not_found')
      end
    end

    context 'when incorrect password' do
      before do
        allow(claim).to receive(:authenticate).with(password).and_return false
      end

      it 'adds error' do
        expect(subject.save).to eq(false)
        expect(subject.errors[:password]).to include I18n.t('errors.user_session.invalid')
      end
    end
  end
end
