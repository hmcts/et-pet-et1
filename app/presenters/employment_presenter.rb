class EmploymentPresenter < Presenter
  present :job_title

  def was_employed
    yes_no target.present?
  end

  def start_date
    date target.start_date
  end

  present :average_hours_worked_per_week

  def gross_pay
    pay_for __method__
  end

  def net_pay
    pay_for __method__
  end

  def enrolled_in_pension_scheme
    yes_no target.enrolled_in_pension_scheme
  end

  present :benefit_details

  def current_situation
    if target.current_situation
      t "simple_form.options.employment.current_situation.#{target.current_situation}"
    end
  end

  def end_date
    date target.end_date
  end

  def worked_notice_period_or_paid_in_lieu
    yes_no target.worked_notice_period_or_paid_in_lieu
  end

  def notice_period_end_date
    date target.notice_period_end_date
  end

  def notice_period_pay
    if [notice_pay_period_count, notice_pay_period_type].all? &:present?
      "#{notice_pay_period_count} #{notice_pay_period_type}"
    end
  end

  def new_job
    yes_no target.found_new_job
  end

  def new_job_gross_pay
    if [target.new_job_gross_pay, target.new_job_gross_pay_frequency].all? &:present?
      number_to_currency(target.new_job_gross_pay) + ' ' + period_type(target.new_job_gross_pay_frequency)
    end
  end

  def new_job_start_date
    date target.new_job_start_date
  end

  private

  def items
    if target.blank?
      %i<was_employed>
    else
      super.reject { |i| items_to_omit.include? i }
    end
  end

  def items_to_omit
    delete = %i<was_employed>

    delete.concat %i<new_job_start_date new_job_gross_pay> unless target.found_new_job?

    delete.push :notice_period_pay unless target.worked_notice_period_or_paid_in_lieu?

    case target.current_situation
    when "still_employed"
      delete.concat %i<end_date worked_notice_period_or_paid_in_lieu notice_period_end_date notice_period_pay>
    when "notice_period"
      delete.concat %i<end_date worked_notice_period_or_paid_in_lieu notice_period_pay>
    when "employment_terminated"
      delete.push :notice_period_end_date
    end

    delete
  end

  def period_type(period_type)
    t "claim_reviews.show.employment.pay_period_#{period_type}"
  end

  def pay_for(pay)
    period = target.send(:"#{pay}_period_type")
    pay    = target.send(pay)

    if [pay, period].all?(&:present?)
      number_to_currency(pay) + ' ' + period_type(period)
    end
  end


end
