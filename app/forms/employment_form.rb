class EmploymentForm < Form
  attributes :job_title, :start_date, :average_hours_worked_per_week,
    :gross_pay, :gross_pay_period_type, :net_pay, :net_pay_period_type,
    :enrolled_in_pension_scheme, :benefit_details, :current_situation,
    :end_date, :worked_notice_period_or_paid_in_lieu,
    :notice_period_end_date, :notice_pay_period_count, :notice_pay_period_count,
    :notice_pay_period_type, :found_new_job, :new_job_start_date,
    :new_job_gross_pay, :new_job_gross_pay_frequency

  dates :start_date, :end_date, :notice_period_end_date, :new_job_start_date

  booleans :was_employed

  private def target
    resource.employment || resource.build_employment
  end
end
