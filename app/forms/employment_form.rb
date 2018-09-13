class EmploymentForm < Form
  CURRENT_SITUATION  = [:still_employed, :notice_period, :employment_terminated].freeze
  PAY_PERIODS        = [:weekly, :monthly].freeze
  NOTICE_PAY_PERIODS = [:weeks, :months].freeze

  attribute :average_hours_worked_per_week,        :float
  attribute :benefit_details,                      :string
  attribute :current_situation,                    :string
  attribute :end_date,                             :gds_date_type
  attribute :enrolled_in_pension_scheme,           :boolean
  attribute :found_new_job,                        :boolean
  attribute :gross_pay,                            :integer
  attribute :gross_pay_period_type,                :string
  attribute :job_title,                            :string
  attribute :net_pay,                              :integer
  attribute :net_pay_period_type,                  :string
  attribute :new_job_gross_pay,                    :integer
  attribute :new_job_gross_pay_frequency,          :string
  attribute :new_job_start_date,                   :gds_date_type
  attribute :notice_pay_period_count,              :float
  attribute :notice_pay_period_type,               :string
  attribute :notice_period_end_date,               :gds_date_type
  attribute :start_date,                           :gds_date_type
  attribute :worked_notice_period_or_paid_in_lieu, :boolean

  [:gross_pay, :net_pay, :new_job_gross_pay].each do |attribute|
    define_method("#{attribute}=") do |v|
      if v.respond_to?(:gsub)
        write_attribute attribute, v.delete(',')
      else
        write_attribute attribute, v
      end
    end
  end

  validates :start_date, date: true
  validates :end_date, date: true
  validates :new_job_start_date, date: true
  validates :notice_period_end_date, date: true

  boolean :was_employed

  before_validation :reset_irrelevant_fields!, if: :was_employed?
  before_validation :destroy_target!, unless: :was_employed?

  validates :gross_pay, :net_pay, :new_job_gross_pay, numericality: { allow_blank: true }

  validates :new_job_gross_pay_frequency, presence: { if: :new_job_gross_pay? }
  validates :notice_pay_period_type,      presence: { if: :notice_pay_period_count? }
  validates :gross_pay_period_type,       presence: { if: :gross_pay? }
  validates :net_pay_period_type,         presence: { if: :net_pay? }

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
    unwanted = CURRENT_SITUATION - [current_situation.to_sym, :still_employed]
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
