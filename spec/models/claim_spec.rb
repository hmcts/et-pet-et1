require 'rails_helper'

describe Claim do
  it { is_expected.to have_secure_password }

  it { is_expected.to have_many(:claimants).dependent(:destroy) }
  it { is_expected.to have_many(:respondents).dependent(:destroy) }
  it { is_expected.to have_one(:representative).dependent(:destroy) }
  it { is_expected.to have_one(:employment).dependent(:destroy) }
  it { is_expected.to have_one(:office).dependent(:destroy) }
  it { is_expected.to have_one(:primary_claimant) }
  it { is_expected.to have_one(:primary_respondent) }
  it { is_expected.to have_one(:payment) }

  let(:claim) { Claim.new(id: 1) }

  %i<created_at amount reference>.each do |meth|
    describe "#payment_#{meth}" do
      context 'when #payment is nil' do
        it 'returns nil' do
          expect(claim.send "payment_#{meth}").to be nil
        end
      end

      context 'when #payment is not nil' do
        let(:payment) { double :payment }
        before { allow(claim).to receive(:payment).and_return payment }

        it 'delegates to #payment' do
          expect(payment).to receive(meth).and_return 'lol'
          expect(claim.send "payment_#{meth}").to eq 'lol'
        end
      end
    end
  end

  describe "#payment_present?" do
    context 'when #payment is nil' do
      it 'returns false' do
        expect(claim.payment_present?).to be false
      end
    end

    context 'when #payment is not nil' do
      let(:payment) { double :payment }
      before { allow(claim).to receive(:payment).and_return payment }

      it 'delegates to #payment' do
        expect(payment).to receive(:present?).and_return true
        expect(claim.payment_present?).to eq true
      end
    end
  end

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

  describe '#submittable?' do
    let(:attributes) do
      {
        primary_claimant:   Claimant.new,
        primary_respondent: Respondent.new
      }
    end

    context 'when the minimum information is incomplete' do
      it 'returns false' do
        expect(attributes.none? { |key, _| Claim.new(attributes.except key).submittable? }).to be true
      end
    end

    context 'when the minimum information is complete' do
      subject { Claim.new attributes }
      its(:submittable?) { is_expected.to be true }
    end
  end

  describe '#fee_calculation' do
    it 'delegates to ClaimFeeCalculator.calculate' do
      expect(ClaimFeeCalculator).to receive(:calculate).with claim: claim
      claim.fee_calculation
    end
  end

  describe '#payment_applicable?' do
    before do
      allow(PaymentGateway).to receive(:available?).and_return true
      allow(subject).to receive(:fee_group_reference?).and_return true
      allow(ClaimFeeCalculator).to receive(:calculate).with(claim: subject).
        and_return double(ClaimFeeCalculator::Calculation, :fee_to_pay? => true)
    end

    context 'when the payment gateway is up, a fee group reference is present, and a payment is due' do
      it 'is true' do
        expect(subject.payment_applicable?).to be true
      end
    end

    context 'but the payment gateway is unavailable' do
      before { allow(PaymentGateway).to receive(:available?).and_return false }

      it 'returns false' do
        expect(subject.payment_applicable?).to be false
      end
    end

    context 'when the fee group reference is missing' do
      before { allow(subject).to receive(:fee_group_reference?).and_return false }

      it 'returns false' do
        expect(subject.payment_applicable?).to be false
      end
    end

    context 'when the application fee after remissions are applied is zero' do
      before do
        allow(ClaimFeeCalculator).to receive(:calculate).with(claim: subject).
          and_return double(ClaimFeeCalculator::Calculation, :fee_to_pay? => false)
      end

      it 'returns false' do
        expect(subject.payment_applicable?).to be false
      end
    end
  end

  describe '#state' do
    describe 'for a new record' do
      it 'is "created"' do
        expect(subject.state).to eq('created')
      end
    end
  end

  describe '#submit!' do
    context 'transitioning state from "created"' do
      context 'when the claim is in a submittable state' do
        before { allow(subject).to receive_messages :submittable? => true, :save! => true }

        context 'and payment is required' do
          before { allow(subject).to receive(:payment_applicable?).and_return true }

          it 'transitions state to "payment_required"' do
            subject.submit!
            expect(subject.state).to eq('payment_required')
          end
        end

        context 'and payment is not required' do
          before { allow(subject).to receive(:payment_applicable?).and_return false }

          it 'transitions state to "enqueued_for_submission"' do
            subject.submit!
            expect(subject.state).to eq('enqueued_for_submission')
          end

          it 'saves the claim' do
            expect(subject).to receive(:save!)
            subject.submit!
          end

          it 'enqueues the claim for submission'
        end
      end

      context 'when the claim is not in a submittable state' do
        before { allow(subject).to receive(:submittable?).and_return false }

        it 'raises "StateMachine::InvalidTransition"' do
          expect { subject.submit! }.to raise_error StateMachine::InvalidTransition
        end
      end
    end
  end

  describe '#enqueue' do
    context 'transitioning state from "payment_required"' do
      before do
        allow(subject).to receive_messages :save! => true
        subject.state = 'payment_required'
      end

      it 'transitions state to "enqueued_for_submission"' do
        subject.enqueue!
        expect(subject.state).to eq('enqueued_for_submission')
      end

      it 'saves the claim' do
        expect(subject).to receive(:save!)
        subject.enqueue!
      end

      it 'enqueues the claim for submission'

    end
  end

  describe '#finalize!' do
    context 'transitioning state from "enqueued_for_submission"' do
      before do
        allow(subject).to receive_messages :save! => true
        subject.state = 'enqueued_for_submission'
      end

      it 'transitions state to "submitted"' do
        subject.finalize!
        expect(subject.state).to eq('submitted')
      end

      it 'saves the claim' do
        expect(subject).to receive(:save!)
        subject.finalize!
      end
    end
  end
end
