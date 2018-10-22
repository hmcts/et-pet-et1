require 'rails_helper'

RSpec.describe PdfForm::EmploymentPresenter, type: :presenter do
  let(:pdf_form_employment_presenter) { described_class.new(employment) }

  let(:hash) { pdf_form_employment_presenter.to_h }

  describe '#to_h' do
    context 'when notice period is monthly' do
      let(:employment) {
        Employment.new(
          notice_pay_period_type: 'months',
          notice_pay_period_count: 1
        )
      }

      describe 'includes notice period in months' do
        it { expect(hash).to include('6.3 weeks' => nil) }
        it { expect(hash).to include('6.3 months' => 1) }
      end
    end

    context 'when lieu is blank' do
      let(:employment) {
        Employment.new(
          worked_notice_period_or_paid_in_lieu: nil
        )
      }

      it 'includes notice period in months' do
        expect(hash).to include('6.3 tick boxes' => 'Off')
      end
    end

    describe 'when notice period is weekly' do
      let(:employment) {
        Employment.new(
          notice_pay_period_type: 'weeks',
          notice_pay_period_count: 1
        )
      }

      describe 'includes notice period in weeks' do
        it { expect(hash).to include('6.3 weeks' => 1) }
        it { expect(hash).to include('6.3 months' => nil) }
      end
    end

    context 'when pension is blank' do
      let(:employment) {
        Employment.new(
          enrolled_in_pension_scheme: nil
        )
      }

      it 'includes notice period in months' do
        expect(hash).to include('6.4 tick boxes' => 'Off')
      end
    end

    context 'when emplyoment in the past' do
      let(:employment) { Employment.new(end_date: Date.yesterday) }

      it 'has ended' do
        expect(hash).to include('5.1 tick boxes' => 'no')
      end
    end

    context 'when employment in the future' do
      let(:employment) { Employment.new(end_date: Date.tomorrow) }

      it 'is continuing' do
        expect(hash).to include('5.1 tick boxes' => 'yes')
      end
    end

    context 'when no employment end date' do
      let(:employment) { Employment.new(end_date: Date.tomorrow) }

      it 'is continuing' do
        expect(hash).to include('5.1 tick boxes' => 'yes')
      end
    end
  end
end
