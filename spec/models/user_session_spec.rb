require 'rails_helper'

describe UserSession do

  let(:claim)           { Claim.new password_digest: }
  let(:reference)       { ApplicationReference.normalize 'reference' }
  let(:password)        { 'password' }
  let(:password_digest) { 'gff76tyuiy' }
  let(:session) { subject }

  before do
    session.reference = reference
    session.password = password
    allow(Claim).to receive(:find_by).with(application_reference: reference).and_return claim
    allow(claim).to receive(:authenticate).with(password).and_return true
  end

  describe 'validations' do
    context 'when the claim is immutable?' do
      before { allow(claim).to receive(:immutable?).and_return true }

      context 'when the password authenticates' do
        before { session.valid? }

        it 'adds an error to base' do
          expect(session.errors[:base]).to include I18n.t('errors.user_session.immutable')
        end
      end

      context 'when the password does not authenticate' do
        before do
          allow(claim).to receive(:authenticate).and_return false
          session.valid?
        end

        it 'adds no errors to base so information is not revealed to unauthorised persons' do
          expect(session.errors[:base]).to be_empty
        end
      end
    end
  end

  describe '#claim' do
    it 'finds the claim from the reference' do
      expect(session.claim).to eq(claim)
    end
  end

  describe '#authenticates' do
    it { expect(session.valid?).to be(true) }
    it { expect(session.errors).to be_empty }

    context 'when invalid reference' do
      before do
        allow(Claim).to receive(:find_by).with(application_reference: reference).and_return nil
      end

      it { expect(session.valid?).to be(false) }

      it 'adds error' do
        session.valid?
        expect(session.errors[:reference]).to include I18n.t('errors.user_session.not_found')
      end
    end

    context 'when incorrect password' do
      before do
        allow(claim).to receive(:authenticate).with(password).and_return false
      end

      it { expect(session.valid?).to be(false) }

      it 'adds error' do
        session.valid?
        expect(session.errors[:password]).to include I18n.t('errors.user_session.invalid')
      end
    end
  end
end
