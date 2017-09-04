require 'rails_helper'

RSpec.describe EmploymentPresenter, type: :presenter do
  let(:employment_presenter) { described_class.new employment }

  let(:employment) do
    Employment.new \
      start_date: Date.civil(2000, 2, 1), average_hours_worked_per_week: 40.0,
      gross_pay: 500, gross_pay_period_type: 'weekly', net_pay: 490,
      net_pay_period_type: 'weekly', enrolled_in_pension_scheme: false,
      benefit_details: 'Company car', current_situation: 'employment_terminated',
      end_date: Date.civil(2010, 12, 1),
      worked_notice_period_or_paid_in_lieu: false,
      notice_period_end_date: Date.civil(2010, 12, 2), notice_pay_period_count: 4,
      notice_pay_period_type: 'weeks', new_job_start_date: Date.civil(2011, 1, 1),
      new_job_gross_pay: 100, new_job_gross_pay_frequency: 'monthly',
      found_new_job: true
  end

  it { expect(employment_presenter.start_date).to eq '01 February 2000' }
  it { expect(employment_presenter.average_hours_worked_per_week).to eq 40.0 }
  it { expect(employment_presenter.gross_pay).to eq '£500.00 per week' }
  it { expect(employment_presenter.net_pay).to eq '£490.00 per week' }
  it { expect(employment_presenter.enrolled_in_pension_scheme).to eq 'No' }
  it { expect(employment_presenter.benefit_details).to eq 'Company car' }
  it { expect(employment_presenter.current_situation).to eq "No longer working for this employer" }
  it { expect(employment_presenter.end_date).to eq '01 December 2010' }
  it { expect(employment_presenter.worked_notice_period_or_paid_in_lieu).to eq 'No' }
  it { expect(employment_presenter.notice_period_end_date).to eq '02 December 2010' }
  it { expect(employment_presenter.notice_period_pay).to eq '4.0 weeks' }
  it { expect(employment_presenter.new_job).to eq 'Yes' }
  it { expect(employment_presenter.new_job_gross_pay).to eq '£100.00 per month' }

  describe '#each_item' do
    context 'when target is blank' do
      before { employment_presenter.target = nil }

      specify do
        expect { |b| employment_presenter.each_item(&b) }.to yield_successive_args [:was_employed, 'No']
      end
    end

    context 'when target is not blank' do
      it 'does not contain :was_employed' do
        expect(employment_presenter.to_enum(:each_item)).
          to match_array [[:job_title, nil], [:start_date, "01 February 2000"],
                          [:average_hours_worked_per_week, 40.0], [:gross_pay, "£500.00 per week"],
                          [:net_pay, "£490.00 per week"], [:enrolled_in_pension_scheme, "No"],
                          [:benefit_details, "Company car"], [:current_situation, "No longer working for this employer"],
                          [:end_date, "01 December 2010"], [:worked_notice_period_or_paid_in_lieu, "No"],
                          [:new_job, "Yes"], [:new_job_gross_pay, "£100.00 per month"],
                          [:new_job_start_date, "01 January 2011"]]
      end

      context "when found_new_job is false" do
        before { employment.found_new_job = false }

        it 'does not include new job fields' do
          expect(employment_presenter.to_enum(:each_item)).
            to match_array [[:job_title, nil], [:start_date, "01 February 2000"],
                            [:average_hours_worked_per_week, 40.0], [:gross_pay, "£500.00 per week"],
                            [:net_pay, "£490.00 per week"], [:enrolled_in_pension_scheme, "No"],
                            [:benefit_details, "Company car"], [:current_situation, "No longer working for this employer"],
                            [:end_date, "01 December 2010"], [:worked_notice_period_or_paid_in_lieu, "No"],
                            [:new_job, "No"]]
        end
      end

      describe 'current_situation' do
        context 'when still_employed' do
          before do
            # Employment won't have new job values in this state. Form clears them
            employment.assign_attributes current_situation: :still_employed,
                                         new_job_start_date: nil, new_job_gross_pay: nil
          end

          it 'does not include fields pertaining to employment end date or notice period' do
            expect(employment_presenter.to_enum(:each_item)).
              to match_array [[:job_title, nil], [:start_date, "01 February 2000"],
                              [:average_hours_worked_per_week, 40.0], [:gross_pay, "£500.00 per week"],
                              [:net_pay, "£490.00 per week"], [:enrolled_in_pension_scheme, "No"],
                              [:benefit_details, "Company car"], [:current_situation, "Still working for this employer"],
                              [:new_job, "Yes"], [:new_job_gross_pay, nil], [:new_job_start_date, nil]]

          end
        end

        context 'when notice_period' do
          before do
            # Employment won't have new job values in this state. Form clears them
            employment.assign_attributes current_situation: :notice_period,
                                         new_job_start_date: nil, new_job_gross_pay: nil
          end

          it 'does not include fields pertaining to employment end date or notice period pay' do
            expect(employment_presenter.to_enum(:each_item)).
              to match_array [[:job_title, nil], [:start_date, "01 February 2000"],
                              [:average_hours_worked_per_week, 40.0], [:gross_pay, "£500.00 per week"],
                              [:net_pay, "£490.00 per week"], [:enrolled_in_pension_scheme, "No"],
                              [:benefit_details, "Company car"], [:current_situation, "Working a notice period for this employer"],
                              [:notice_period_end_date, "02 December 2010"], [:new_job, "Yes"],
                              [:new_job_gross_pay, nil], [:new_job_start_date, nil]]
          end
        end

        context 'when employment_terminated' do
          before { employment.current_situation = :employment_terminated }

          it 'does not include fields pertaining to employment end date or notice period pay' do
            expect(employment_presenter.to_enum(:each_item)).
              to match_array [[:job_title, nil], [:start_date, "01 February 2000"],
                              [:average_hours_worked_per_week, 40.0], [:gross_pay, "£500.00 per week"],
                              [:net_pay, "£490.00 per week"], [:enrolled_in_pension_scheme, "No"],
                              [:benefit_details, "Company car"], [:current_situation, "No longer working for this employer"],
                              [:end_date, "01 December 2010"], [:worked_notice_period_or_paid_in_lieu, "No"],
                              [:new_job, "Yes"], [:new_job_gross_pay, "£100.00 per month"],
                              [:new_job_start_date, "01 January 2011"]]
          end
        end
      end

      describe 'when target.worked_notice_period_or_paid_in_lieu' do
        context 'is true' do
          before { employment.worked_notice_period_or_paid_in_lieu = true }

          it 'includes notice period pay' do
            expect(employment_presenter.to_enum(:each_item)).
              to match_array [[:job_title, nil], [:start_date, "01 February 2000"],
                              [:average_hours_worked_per_week, 40.0], [:gross_pay, "£500.00 per week"],
                              [:net_pay, "£490.00 per week"], [:enrolled_in_pension_scheme, "No"],
                              [:benefit_details, "Company car"], [:current_situation, "No longer working for this employer"],
                              [:end_date, "01 December 2010"], [:worked_notice_period_or_paid_in_lieu, "Yes"],
                              [:notice_period_pay, "4.0 weeks"], [:new_job, "Yes"],
                              [:new_job_gross_pay, "£100.00 per month"], [:new_job_start_date, "01 January 2011"]]
          end
        end

        context 'is false' do
          it 'includes notice period pay' do
            expect(employment_presenter.to_enum(:each_item)).
              to match_array [[:job_title, nil], [:start_date, "01 February 2000"],
                              [:average_hours_worked_per_week, 40.0], [:gross_pay, "£500.00 per week"],
                              [:net_pay, "£490.00 per week"], [:enrolled_in_pension_scheme, "No"],
                              [:benefit_details, "Company car"], [:current_situation, "No longer working for this employer"],
                              [:end_date, "01 December 2010"], [:worked_notice_period_or_paid_in_lieu, "No"],
                              [:new_job, "Yes"], [:new_job_gross_pay, "£100.00 per month"],
                              [:new_job_start_date, "01 January 2011"]]
          end
        end
      end
    end
  end
end
