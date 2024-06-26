class EmploymentForm < Form
  CURRENT_SITUATION  = [:still_employed, :notice_period, :employment_terminated].freeze

  attribute :average_hours_worked_per_week,        :float
  attribute :benefit_details,                      :string
  attribute :current_situation,                    :string
  attribute :end_date,                             :et_date
  attribute :enrolled_in_pension_scheme,           :boolean
  attribute :found_new_job,                        :boolean
  attribute :gross_pay,                            :integer
  attribute :pay_period_type,                      :string
  attribute :job_title,                            :string
  attribute :net_pay,                              :integer
  attribute :new_job_gross_pay,                    :integer
  attribute :new_job_gross_pay_frequency,          :string
  attribute :new_job_start_date,                   :et_date
  attribute :notice_pay_period_count,              :float
  attribute :notice_pay_period_type,               :string
  attribute :notice_period_end_date,               :et_date
  attribute :start_date,                           :et_date
  attribute :worked_notice_period_or_paid_in_lieu, :boolean
  attribute :was_employed,                         :boolean
  map_attribute :was_employed, to: :resource

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
  validate :end_date_before_start_date?
  validate :start_date_before_notice_period_end_date?
  validate :date_is_past?
  validates :was_employed, inclusion: [true, false]
  validates :average_hours_worked_per_week,
            numericality: { greater_than: 0, less_than_or_equal_to: 168, allow_blank: true }

  before_validation :reset_irrelevant_fields!, if: :was_employed?
  before_validation :destroy_target!, unless: :was_employed?

  validates :gross_pay, :new_job_gross_pay, numericality: { allow_blank: true }
  validates :net_pay, numericality: { allow_blank: true, allow_nil: true }
  validates :net_pay, numericality: { less_than_or_equal_to: :gross_pay, allow_blank: true, allow_nil: true },
                      if: :gross_pay?

  validates :new_job_gross_pay_frequency, presence: { if: :new_job_gross_pay? }
  validates :notice_pay_period_type,      presence: { if: :notice_pay_period_count? }
  validates :pay_period_type,             presence: { if: :gross_pay? || net_pay? }
  validates :current_situation,           presence: { if: :was_employed? }

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
    return if current_situation.blank?

    unwanted = CURRENT_SITUATION - [current_situation.to_sym, :still_employed]
    unwanted.each { |situation| send("reset_#{situation}!") }
  end

  def reset_notice_period!
    self.notice_period_end_date = nil
  end

  def reset_employment_terminated!
    assign_attributes end_date: nil,
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

  def end_date_before_start_date?
    return if end_date.blank? || start_date.blank?
    return unless end_date.is_a?(Date) && start_date.is_a?(Date)

    return unless end_date < start_date

    errors.add(:end_date, :end_date_before_start_date)
  end

  def start_date_before_notice_period_end_date?
    return if notice_period_end_date.blank? || start_date.blank?
    return unless notice_period_end_date.is_a?(Date) && start_date.is_a?(Date)

    return unless notice_period_end_date < start_date

    errors.add(:notice_period_end_date, :notice_period_end_date_before_start_date)
  end

  def date_is_past?
    return if end_date.blank? || start_date.blank?
    return unless end_date.is_a?(Date) && start_date.is_a?(Date)

    errors.add(:start_date, :date_in_future) if Time.zone.today < start_date
    return unless Time.zone.today < end_date

    errors.add(:end_date, :date_in_future)
  end
end
