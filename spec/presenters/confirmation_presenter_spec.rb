require 'rails_helper'

RSpec.describe ConfirmationPresenter, type: :presenter do
  subject { described_class.new claim }

  let(:payment) { Payment.new amount: 250 }

  let(:claim) do
    Claim.create! state: 'submitted', submitted_at: Date.civil(2014, 1, 1)
  end

  describe 'submission_information' do
    context 'when there is an associated fee office' do
      before { claim.build_office name: 'Brum', address: 'Brum lane, B1 1AA' }

      context 'and no claimants seeking remission' do
        it 'has the submitted date, the name, and address of the fee centre' do
          expect(subject.submission_information).
            to eq 'Submitted 01 January 2014 to tribunal office Brum, Brum lane, B1 1AA'
        end
      end

      context 'and claimants are seeking remission' do
        before { claim.remission_claimant_count = 1 }

        it 'is the submission date' do
          expect(subject.submission_information).
            to eq 'Submitted 01 January 2014'
        end
      end
    end

    context 'when there is no associated fee office' do
      it 'is the submission date' do
        expect(subject.submission_information).
        to eq 'Submitted 01 January 2014'
      end
    end
  end

  describe '#each_item' do
    it 'yields the submission information' do
      expect { |b| subject.each_item &b }.
        to yield_successive_args [:submission_information, 'Submitted 01 January 2014']
    end
  end

  context 'when payment information is present' do
    before { claim.payment = payment }

    describe '#each_item' do
      it 'yields the payment information' do
        expect { |b| subject.each_item &b }.
          to yield_successive_args [:submission_information, 'Submitted 01 January 2014'],
            [:payment_amount, '£250.00']
      end
    end

    its(:payment_amount) { is_expected.to eq '£250.00' }
  end

  context 'when attachments are present' do
    before do
      allow(claim).to receive(:additional_information_rtf).
        and_return instance_double(AttachmentUploader, filename: 'lolz.rtf')
      allow(claim).to receive(:additional_claimants_csv).
        and_return instance_double(AttachmentUploader, filename: 'peepz.csv')
    end

    describe '#each_item' do
      it 'yields the payment information' do
        expect { |b| subject.each_item &b }.
        to yield_successive_args [:submission_information, 'Submitted 01 January 2014'],
        [:attachments, 'lolz.rtf<br />peepz.csv']
      end
    end

    its(:attachments) { is_expected.to eq 'lolz.rtf<br />peepz.csv' }
  end
end
