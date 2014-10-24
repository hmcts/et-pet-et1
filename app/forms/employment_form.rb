class EmploymentForm < Form

  attributes :job_title, :start_date, :average_hours_worked_per_week,
    :gross_pay, :gross_pay_period_type, :net_pay, :net_pay_period_type,
    :enrolled_in_pension_scheme, :benefit_details, :current_situation,
    :end_date, :worked_notice_period_or_paid_in_lieu,
    :notice_period_end_date, :notice_pay_period_count, :notice_pay_period_count,
    :notice_pay_period_type, :found_new_job, :new_job_start_date,
    :new_job_gross_pay, :new_job_gross_pay_frequency

  %i<gross_pay net_pay new_job_gross_pay>.each do |attribute|
    define_method("#{attribute}=") do |v|
      v = v.nil? ? v : v.gsub(',', '')
      attributes[attribute] = v
    end
  end

  dates :start_date, :end_date, :notice_period_end_date, :new_job_start_date

  boolean :was_employed

  validates :gross_pay, :net_pay, :new_job_gross_pay, numericality: { allow_blank: true }

  def was_employed
    @was_employed ||= target.persisted?
  end

  private

  def clear_irrelevant_fields
    if was_employed?
      (FormOptions::CURRENT_SITUATION - [current_situation]).each do |situation|
        clear_method = "clear_#{situation}"
        send(clear_method) if respond_to?(clear_method, true)
      end
      clear_notice_pay_period
      clear_new_job
    else
      target.destroy
    end
  end

  def clear_notice_period
    self.notice_period_end_date = nil
  end

  def clear_employment_terminated
    self.end_date = nil
    self.worked_notice_period_or_paid_in_lieu = nil
    self.found_new_job = nil
  end

  def clear_notice_pay_period
    unless worked_notice_period_or_paid_in_lieu
      self.notice_pay_period_count = nil
      self.notice_pay_period_type = nil
    end
  end

  def clear_new_job
    unless found_new_job
      self.new_job_start_date = nil
      self.new_job_gross_pay = nil
      self.new_job_gross_pay_frequency = nil
    end
  end

  def still_employed
    notice_period_fields + employment_terminated_fields
  end

  def target
    resource.employment || resource.build_employment
  end
end
