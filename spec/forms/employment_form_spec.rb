require 'rails_helper'

RSpec.describe EmploymentForm, :type => :form do
  it_behaves_like 'it parses and validates multiparameter dates',
    :start_date, :end_date, :notice_period_end_date, :new_job_start_date

  subject { described_class.new { |f| f.resource = Claim.new } }

  describe '#was_employed' do
    context 'when the underlying claim does not have an employment relation' do
      it 'is false' do
        expect(subject.was_employed).to be false
      end
    end

    context 'when the underlying claim does not have an employment relation' do
      before { subject.resource.employment = Employment.new }

      it 'is true' do
        expect(subject.was_employed).to be true
      end
    end
  end
end
