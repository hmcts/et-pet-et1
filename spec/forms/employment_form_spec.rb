require 'rails_helper'

RSpec.describe EmploymentForm, :type => :form do
  subject { described_class.new resource }

  let(:resource)   { Claim.new employment: employment }
  let(:employment) { Employment.new }

  it_behaves_like 'it parses dates',
    :start_date, :end_date, :notice_period_end_date, :new_job_start_date

  describe 'validations' do
    %i<gross_pay net_pay new_job_gross_pay>.each do |attribute|
      it { is_expected.to validate_numericality_of(attribute).allow_nil }
    end

    { :new_job_gross_pay_frequency => :new_job_gross_pay, :notice_pay_period_type => :notice_pay_period_count,
      :gross_pay_period_type => :gross_pay, :net_pay_period_type => :net_pay }.
      each do |type, pay|
        describe "#{type}" do
          context "when #{pay} is true" do
            before { subject.send "#{pay}=", "100" }

            it { is_expected.to validate_presence_of type }
          end

          context "when #{pay} is false" do
            it { is_expected.to_not validate_presence_of type }
          end
        end
      end
  end

  %i<gross_pay net_pay new_job_gross_pay>.each do |attr|
    describe "#{attr}=" do
      before { subject.send "#{attr}=", '10,000' }

      it 'strips commas entered by the user' do
        expect(subject.send(attr)).to eq 10000
      end
    end
  end

  describe '#was_employed' do
    context 'when the employment model has not been persisted' do
      before { allow(employment).to receive_messages :persisted? => false }

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

  describe 'callbacks' do
    context 'was not employed' do
      before { subject.was_employed = 'false' }

      it 'destroys the representative relation' do
        expect(employment).to receive :destroy
        subject.save
      end
    end

    context 'was employed' do
      before do
        subject.assign_attributes worked_notice_period_or_paid_in_lieu: true,
          notice_period_end_date: 1.week.ago.to_date, end_date: Date.today,
          notice_pay_period_count: '1', notice_pay_period_type: 'weeks',
          found_new_job: 'true', new_job_start_date: 1.week.from_now.to_date,
          new_job_gross_pay: '100', new_job_gross_pay_frequency: 'monthly',
          was_employed: 'true'
      end

      context 'when still employed' do
        before { subject.current_situation = 'still_employed' }

        context 'previously entered other information' do
          it 'clears other fields' do
            subject.valid?

            expect(subject.worked_notice_period_or_paid_in_lieu).to be nil
            expect(subject.notice_period_end_date).to be nil
            expect(subject.end_date).to be nil
            expect(subject.notice_pay_period_count).to be nil
            expect(subject.new_job_start_date).to be nil
          end
        end
      end

      context 'when in notice period' do
        before { subject.current_situation = 'notice_period' }

        it 'clears other fields but keeps notice period end date' do
          subject.valid?

          expect(subject.notice_period_end_date).not_to be nil
          expect(subject.end_date).to be nil
          expect(subject.worked_notice_period_or_paid_in_lieu).to be nil
          expect(subject.notice_pay_period_count).to be nil
          expect(subject.new_job_start_date).to be nil
        end
      end

      context 'when employment terminated' do
        before { subject.current_situation = 'employment_terminated' }

        context 'when previously entered new job details' do
          context 'when selecting no new job' do
            before { subject.found_new_job = false }

            it 'clears new job details' do
              subject.valid?

              expect(subject.new_job_start_date).to be nil
              expect(subject.new_job_gross_pay).to be nil
              expect(subject.new_job_gross_pay_frequency).to be nil
            end
          end

          context 'when selecting new job' do
            before { subject.found_new_job = 'true' }

            it 'new job details are not removed' do
              subject.valid?

              expect(subject.new_job_start_date).not_to be nil
              expect(subject.new_job_gross_pay).not_to be nil
              expect(subject.new_job_gross_pay_frequency).not_to be nil
            end
          end
        end

        context 'when previously entered notice period details' do
          context 'when selecting no notice period' do
            before { subject.worked_notice_period_or_paid_in_lieu = 'false' }
            it 'clears notice period details' do
              subject.valid?

              expect(subject.notice_pay_period_count).to be nil
              expect(subject.notice_pay_period_type).to be nil
            end
          end
        end
      end
    end
  end
end
