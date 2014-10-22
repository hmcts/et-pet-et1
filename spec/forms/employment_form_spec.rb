require 'rails_helper'

RSpec.describe EmploymentForm, :type => :form do
  it_behaves_like 'it parses and validates multiparameter dates',
    :start_date, :end_date, :notice_period_end_date, :new_job_start_date

  subject { described_class.new { |f| f.resource = Claim.new } }

  before { subject.resource.employment = employment }
  let(:employment) { Employment.new }

  describe '#was_employed' do

    context 'when the employment model has not been persisted' do
      it 'is false' do
        expect(subject.was_employed).to be false
      end
    end

    context 'when the employment model has been persisted' do
      before { allow(employment).to receive_messages :persisted? => true }

      it 'is true' do
        expect(subject.was_employed).to be true
      end
    end
  end

  describe '#save' do
    context 'when was_employed? == false' do
      before { subject.was_employed = false }

      it 'destroys the representative relation' do
        expect(employment).to receive :destroy
        subject.save
      end
    end
  end
end
