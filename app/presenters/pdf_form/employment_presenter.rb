class PdfForm::EmploymentPresenter < PdfForm::BaseDelegator
  PAY_PERIODS = [:weekly, :monthly].freeze

  # rubocop:disable MethodLength
  # rubocop:disable Metrics/AbcSize
  def to_h
    {
      "5.1 employment start" => format_date(start_date),
      "5.1 tick boxes" => tri_state(end_date.nil? || end_date.future?),
      "5.1 employment end" => format_date(end_date),
      "5.1 not ended" => format_date(notice_period_end_date),
      "5.2" => job_title,
      "6.1" => average_hours_worked_per_week,
      "6.2 pay before tax" => gross_pay,
      "6.2 pay before tax tick boxes" => use_or_off(gross_pay_period_type, PAY_PERIODS),
      "6.2 normal pay" => net_pay,
      "6.2 normal pay tick boxes" => use_or_off(net_pay_period_type, PAY_PERIODS),
      "6.3 tick boxes" => tri_state(worked_notice_period_or_paid_in_lieu),
      "6.3 weeks" => notice_period('weekly'),
      "6.3 months" => notice_period('monthly'),
      "6.4 tick boxes" => tri_state(enrolled_in_pension_scheme),
      "6.5" => benefit_details,
      "7.1 tick boxes" => tri_state(found_new_job),
      "7.2" => format_date(new_job_start_date),
      "7.3" => new_job_gross_pay
    }
  end
  # rubocop:enable MethodLength
  # rubocop:enable Metrics/AbcSize

  private

  def notice_period(type)
    type.to_sym == notice_pay_period_type.try(:to_sym) ? notice_pay_period_count : nil
  end
end
