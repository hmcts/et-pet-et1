require 'rails_helper'

describe EmploymentPresenter do
  subject { EmploymentPresenter.new employment }

  let(:employment) do
    double 'employment',
      start_date: Date.civil(2000, 2, 1), average_hours_worked_per_week: 40.0,
      gross_pay: 500, gross_pay_period_type: 'weekly', net_pay: 490,
      net_pay_period_type: 'weekly', enrolled_in_pension_scheme: false,
      benefit_details: 'Company car', current_situation: 'employment_terminated',
      end_date: Date.civil(2010, 12, 1),
      worked_notice_period_or_paid_in_lieu: false,
      notice_period_end_date: Date.civil(2010, 12, 2), notice_pay_period_count: 4,
      notice_pay_period_type: 'weeks', new_job_start_date: Date.civil(2011, 1, 1),
      new_job_gross_pay: 100, new_job_gross_pay_frequency: 'monthly'
  end

  its(:start_date) { is_expected.to eq '01/02/2000' }
  its(:average_hours_worked_per_week) { is_expected.to eq 40.0 }
  its(:gross_pay) { is_expected.to eq '£500 per week' }
  its(:net_pay)   { is_expected.to eq '£490 per week' }
  its(:enrolled_in_pension_scheme) { is_expected.to eq 'No' }
  its(:benefit_details) { is_expected.to eq 'Company car' }
  its(:current_situation) { is_expected.to eq "No longer working for this employer" }
  its(:end_date) { is_expected.to eq '01/12/2010' }
  its(:worked_notice_period_or_paid_in_lieu) { is_expected.to eq 'No' }
  its(:notice_period_end_date) { is_expected.to eq '02/12/2010' }
  its(:notice_period_pay) { is_expected.to eq '4 weeks' }
  its(:new_job) { is_expected.to eq 'Yes' }
  its(:new_job_gross_pay) { is_expected.to eq '£100 per month' }
end
