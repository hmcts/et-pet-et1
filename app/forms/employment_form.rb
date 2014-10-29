class EmploymentForm < Form
  CURRENT_SITUATION  = %i<still_employed notice_period employment_terminated>.freeze
  PAY_PERIODS        = %i<weekly monthly>.freeze
  NOTICE_PAY_PERIODS = %i<weeks months>.freeze
  CURRENT_SITUATION  = %i<still_employed notice_period employment_terminated>.freeze

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

  before_validation :reset_irrelevant_fields!, if: :was_employed?
  before_validation :destroy_target!, unless: :was_employed?

  validates :gross_pay, :net_pay, :new_job_gross_pay, numericality: { allow_blank: true }

  def was_employed
    @was_employed ||= target.persisted?
  end

  private

  def reset_irrelevant_fields!
    reset_unwanted_situations!
    reset_notice_pay_period! unless worked_notice_period_or_paid_in_lieu
    reset_new_job! unless found_new_job
  end

  def destroy_target!
    target.destroy
  end

  def reset_unwanted_situations!
    unwanted = CURRENT_SITUATION - [current_situation, :still_employed]
    unwanted.each { |situation| send("reset_#{situation}!") }
  end

  def reset_notice_period!
    self.notice_period_end_date = nil
  end

  def reset_employment_terminated!
    assign_attributes end_date: nil, worked_notice_period_or_paid_in_lieu: nil,
      found_new_job: nil
  end

  def reset_notice_pay_period!
    assign_attributes notice_pay_period_count: nil, notice_pay_period_type: nil
  end

  def reset_new_job!
    assign_attributes new_job_start_date: nil, new_job_gross_pay: nil,
      new_job_gross_pay_frequency: nil
  end

  def target
    resource.employment || resource.build_employment
  end
end
