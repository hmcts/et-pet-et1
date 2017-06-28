require 'rails_helper'

describe UserSession do

  let(:claim)           { Claim.new password_digest: password_digest }
  let(:reference)       { 'reference' }
  let(:password)        { 'password' }
  let(:password_digest) { 'gff76tyuiy' }

  before do
    subject.reference = reference
    subject.password = password
    allow(Claim).to receive(:find_by).with(reference: reference).and_return claim
    allow(claim).to receive(:authenticate).with(password).and_return true
  end

  describe 'validations' do
    context 'when the claim is immutable?' do
      before { allow(claim).to receive(:immutable?).and_return true }

      context 'when the password authenticates' do
        before { subject.valid? }

        it 'adds an error to base' do
          expect(subject.errors[:base]).to include I18n.t('errors.user_session.immutable')
        end
      end

      context 'when the password does not authenticate' do
        before do
          allow(claim).to receive(:authenticate).and_return false
          subject.valid?
        end

        it 'adds no errors to base so information is not revealed to unauthorised persons' do
          expect(subject.errors[:base]).to be_empty
        end
      end
    end
  end

  describe '#claim' do
    it 'finds the claim from the reference' do
      expect(subject.claim).to eq(claim)
    end
  end

  describe '#authenticates' do
    it 'does not add any errors when authentication successful' do
      expect(subject.valid?).to be(true)
      expect(subject.errors).to be_empty
    end

    context 'when invalid reference' do
      before do
        allow(Claim).to receive(:find_by).with(reference: reference).and_return nil
      end

      it 'adds error' do
        expect(subject.valid?).to be(false)
        expect(subject.errors[:reference]).to include I18n.t('errors.user_session.not_found')
      end
    end

    context 'when incorrect password' do
      before do
        allow(claim).to receive(:authenticate).with(password).and_return false
      end

      it 'adds error' do
        expect(subject.valid?).to be(false)
        expect(subject.errors[:password]).to include I18n.t('errors.user_session.invalid')
      end
    end
  end
end
