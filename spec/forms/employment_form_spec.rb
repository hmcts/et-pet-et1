require 'rails_helper'

RSpec.describe EmploymentForm, :type => :form do
  it_behaves_like 'it parses and validates multiparameter dates',
    :start_date, :end_date, :notice_period_end_date, :new_job_start_date

  subject { described_class.new { |f| f.resource = Claim.new } }

  before { subject.resource.employment = employment }
  let(:employment) { Employment.new }

  describe 'validations' do
    %i<gross_pay net_pay new_job_gross_pay>.each do |attribute|
      it { is_expected.to validate_numericality_of(attribute).allow_nil }
    end
  end

  %i<gross_pay net_pay new_job_gross_pay>.each do |attr|
    describe "#{attr}=" do
      before { subject.send "#{attr}=", '10,000' }

      it 'strips commas entered by the user' do
        expect(subject.send(attr)).to eq '10000'
      end
    end
  end

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
