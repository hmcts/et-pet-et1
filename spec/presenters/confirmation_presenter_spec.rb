require 'rails_helper'

RSpec.describe ConfirmationPresenter, type: :presenter do
  subject { described_class.new claim }

  let(:claim) { create :claim }

  around do |example|
    travel_to(Time.new(2014).utc) { example.run }
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
      let(:claim) { create :claim, :no_fee_group_reference }
      it 'is the submission date' do
        expect(subject.submission_information).
        to eq 'Submitted 01 January 2014'
      end
    end
  end

  its(:payment_amount) { is_expected.to eq '£250.00' }
  its(:attachments) { is_expected.to eq 'file.rtf<br />file.csv' }

  describe '#each_item' do
    it 'yields the submission information' do
      expect { |b| subject.each_item &b }.
        to yield_successive_args [:submission_information, "Submitted 01 January 2014 to tribunal office Birmingham, Centre City Tower, 5­7 Hill Street, Birmingham B5 4UU"],
        [:attachments, "file.rtf<br />file.csv"],
        [:payment_amount, "£250.00"]
    end

    context 'when payment fails' do
      let(:claim) { create :claim, :payment_no_remission_payment_failed }

      it 'yields payment failure message' do
        expect { |b| subject.each_item &b }.
          to yield_successive_args [:submission_information, "Submitted 01 January 2014 to tribunal office Birmingham, Centre City Tower, 5­7 Hill Street, Birmingham B5 4UU"],
          [:attachments, "file.rtf<br />file.csv"],
          [:payment_amount, "Unable to process payment"]
      end
    end

    context 'when no payment applies' do
      let(:claim) { create :claim, :remission_only }

      it 'yields no payment or fee office information' do
        expect { |b| subject.each_item &b }.
          to yield_successive_args [:submission_information, "Submitted 01 January 2014"],
          [:attachments, "file.rtf<br />file.csv"]
      end
    end

    context 'when no attachments were uploaded' do
      let(:claim) { create :claim, :no_attachments }

      it 'yields text to state no attachments are present' do
        expect { |b| subject.each_item &b }.
          to yield_successive_args [:submission_information, "Submitted 01 January 2014 to tribunal office Birmingham, Centre City Tower, 5­7 Hill Street, Birmingham B5 4UU"],
          [:attachments, "None"],
          [:payment_amount, "£250.00"]
      end
    end
  end
end
