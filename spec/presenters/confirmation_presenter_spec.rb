require 'rails_helper'

RSpec.describe ConfirmationPresenter, type: :presenter do
  subject { described_class.new claim }

  let(:payment) { Payment.new amount: 250 }

  let(:claim) do
    Claim.create! state: 'submitted',
    submitted_at: Date.civil(2014, 1, 1)
  end

  its(:submitted_at) { is_expected.to eq '01 January 2014' }

  describe '#each_item' do
    it 'yields the submission information' do
      expect { |b| subject.each_item &b }.
        to yield_successive_args [:submitted_at, '01 January 2014']
    end
  end

  context 'when payment information is present' do
    before { claim.payment = payment }

    describe '#each_item' do
      it 'yields the payment information' do
        expect { |b| subject.each_item &b }.
          to yield_successive_args [:submitted_at, '01 January 2014'],
            [:payment_amount, '£250.00']
      end
    end

    its(:payment_amount) { is_expected.to eq '£250.00' }
  end

  context 'when attachments are present' do
    let(:path) { Pathname.new "/uploads/claim/attachment/#{claim.reference}" }

    before do
      allow(claim).to receive(:attachment).and_return path + 'lolz.rtf'
      allow(claim).to receive(:additional_claimants_csv).and_return path + 'peepz.csv'
    end

    describe '#each_item' do
      it 'yields the payment information' do
        expect { |b| subject.each_item &b }.
        to yield_successive_args [:submitted_at, '01 January 2014'],
        [:attachments, 'lolz.rtf<br />peepz.csv']
      end
    end

    its(:attachments) { is_expected.to eq 'lolz.rtf<br />peepz.csv' }
  end
end
