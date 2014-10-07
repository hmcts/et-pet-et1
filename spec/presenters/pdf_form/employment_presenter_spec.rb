require 'rails_helper'

RSpec.describe PdfForm::EmploymentPresenter, type: :presenter do
  subject { described_class.new(employment) }
  let(:hash) { subject.to_h }

  describe '#to_h' do
    context 'when notice period is monthly' do
      let(:employment) { Employment.new(
        notice_pay_period_type: 'monthly',
        notice_pay_period_count: 1) }

      it 'includes notice period in months' do
        expect(hash).to include('6.3 weeks' => nil)
        expect(hash).to include('6.3 months' => 1)
      end
    end

    describe 'when notice period is weekly' do
      let(:employment) { Employment.new(
        notice_pay_period_type: 'weekly',
        notice_pay_period_count: 1) }

      it 'includes notice period in weeks' do
        expect(hash).to include('6.3 weeks' => 1)
        expect(hash).to include('6.3 months' => nil)
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
