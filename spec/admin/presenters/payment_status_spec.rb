require 'rails_helper'

RSpec.describe Admin::PaymentStatus, type: :presenter do
  describe '.for' do

    subject { described_class.for claim }

    context 'when the claim is in an immutable state' do
      let(:claim) { create :claim, state: 'created' }
      specify { is_expected.to eq 'Not submitted' }
    end

    context 'when the claim has claimants seeking remission' do
      let(:claim) { create :claim, :remission_only }
      specify { is_expected.to eq 'Remission indicated' }
    end

    context 'when the claim has a payment model assosciated with it' do
      let(:claim) { create :claim, :payment_no_remission }
      specify { is_expected.to eq 'Paid' }
    end

    context 'default status' do
      let(:claim) { create :claim, :payment_failed }
      specify { is_expected.to eq 'Missing payment' }
    end
  end
end
