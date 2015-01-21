class Claim < ActiveRecord::Base
  has_secure_password validations: false
  mount_uploader :additional_information_rtf, AttachmentUploader
  mount_uploader :additional_claimants_csv,   AttachmentUploader
  mount_uploader :pdf,                        ClaimPdfUploader

  has_one :primary_claimant,
    -> { where primary_claimant: true },
    class_name: 'Claimant'

  has_one :primary_respondent,
    -> { where primary_respondent: true },
    class_name: 'Respondent'

  has_many :secondary_claimants,
    -> { where primary_claimant: false },
    class_name: 'Claimant'

  has_many :secondary_respondents,
    -> { where primary_respondent: false },
    class_name: 'Respondent'

  has_many :claimants, dependent: :destroy
  has_many :respondents, dependent: :destroy
  has_one  :representative, dependent: :destroy
  has_one  :employment, dependent: :destroy
  has_one  :office, dependent: :destroy
  has_one  :payment

  delegate :amount, :created_at, :reference, :present?, to: :payment, prefix: true, allow_nil: true
  delegate :file, to: :additional_information_rtf, prefix: true
  delegate :file, to: :additional_claimants_csv, prefix: true
  delegate :file, :url, :present?, :blank?, to: :pdf, prefix: true

  DISCRIMINATION_COMPLAINTS = %i<sex_including_equal_pay disability race age
    pregnancy_or_maternity religion_or_belief sexual_orientation
    marriage_or_civil_partnership gender_reassignment>.freeze
  PAY_COMPLAINTS = %i<redundancy notice holiday arrears other>.freeze
  DESIRED_OUTCOMES = %i<compensation_only tribunal_recommendation
    reinstated_employment_and_compensation new_employment_and_compensation>.freeze

  bitmask :discrimination_claims, as: DISCRIMINATION_COMPLAINTS
  bitmask :pay_claims,            as: PAY_COMPLAINTS
  bitmask :desired_outcomes,      as: DESIRED_OUTCOMES

  after_initialize :setup_state_machine
  after_initialize :generate_application_reference

  before_update -> { secondary_claimants.destroy_all },
    if: :additional_claimants_csv_changed?

  before_update :remove_additional_claimants_csv!,
    if: -> { secondary_claimants.any? }

  def self.find_by_reference(reference)
    normalized = ApplicationReference.normalize(reference)
    find_by(application_reference: normalized)
  end

  def authenticate(password)
    password_digest? && super
  end

  def alleges_discrimination_or_unfair_dismissal?
    discrimination_claims.any? || is_unfair_dismissal?
  end

  def reference
    application_reference
  end

  def claimant_count
    claimants.count + additional_claimants_csv_record_count
  end

  def remove_additional_claimants_csv!
    update_columns(additional_claimants_csv_record_count: 0, additional_claimants_csv: nil)
    super
  end

  # TODO: validate claim against JADU XSD
  def submittable?
    %i<primary_claimant primary_respondent>.all? do |relation|
      send(relation).present?
    end
  end

  def fee_calculation
    ClaimFeeCalculator.calculate claim: self
  end

  def payment_applicable?
    PaymentGateway.available? && fee_to_pay? && fee_group_reference?
  end

  def unpaid?
    payment.blank?
  end

  def remission_applicable?
    fee_calculation.application_fee != fee_calculation.application_fee_after_remission
  end

  def payment_fee_group_reference
    if payment_attempts.zero?
      fee_group_reference
    else
      "#{fee_group_reference}-#{payment_attempts}"
    end
  end

  def generate_pdf!
    PdfFormBuilder.build(self) { |file| self.update pdf: file }
  end

  def attachments
    self.class.uploaders.keys.map(&method(:send)).delete_if { |a| a.file.nil? }
  end

  private

  def state_machine
    @state_machine ||= Claim::FiniteStateMachine.new(claim: self)
  end

  def generate_application_reference
    self.application_reference ||= unique_application_reference
  end

  def unique_application_reference
    loop do
      ref = ApplicationReference.generate
      return ref unless self.class.exists?(application_reference: ref)
    end
  end

  alias_method :setup_state_machine, :state_machine

  delegate *Claim::FiniteStateMachine.instance_methods, to: :state_machine
  delegate :fee_to_pay?, :application_fee, to: :fee_calculation
end
