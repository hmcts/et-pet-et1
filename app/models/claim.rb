class Claim < ActiveRecord::Base
  has_secure_password validations: false
  mount_uploader :claim_details_rtf,          AttachmentUploader
  mount_uploader :additional_claimants_csv,   AttachmentUploader
  mount_uploader :pdf,                        ClaimPdfUploader

  after_create { create_event Event::CREATED }

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

  has_many :events

  has_many :claimants, dependent: :destroy
  has_many :respondents, dependent: :destroy
  has_one  :representative, dependent: :destroy
  has_one  :employment, dependent: :destroy
  has_one  :office, dependent: :destroy
  has_one  :payment

  delegate :amount, :created_at, :reference, :present?, to: :payment, prefix: true, allow_nil: true
  delegate :file, to: :claim_details_rtf, prefix: true
  delegate :file, to: :additional_claimants_csv, prefix: true
  delegate :file, :url, :present?, :blank?, to: :pdf, prefix: true

  validates :secondary_respondents, respondents_count: {
    maximum: Rails.application.config.additional_respondents_limit,
    message: I18n.t('activemodel.errors.models.claim.attributes.secondary_respondents.too_many',
                    max: Rails.application.config.additional_respondents_limit)
  }

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

  delegate :destroy_all, :any?, to: :secondary_claimants, prefix: true

  delegate :fee_to_pay?, :application_fee,
    :application_fee_after_remission, to: :fee_calculation

  before_update :secondary_claimants_destroy_all,
    if: :additional_claimants_csv_changed?

  before_update :remove_additional_claimants_csv!,
    if: :secondary_claimants_any?

  accepts_nested_attributes_for :payment

  def self.find_by_reference(reference)
    find_by application_reference: ApplicationReference.normalize(reference)
  end

  def create_event(event, actor: 'admin', message: nil)
    events.create event: event, actor: actor, message: message
  end

  def authenticate(password)
    password_digest? && super
  end

  def attracts_higher_fee?
    discrimination_claims.any? || is_unfair_dismissal? || is_whistleblowing? || is_protective_award?
  end

  def reference
    application_reference
  end

  def claimant_count
    claimants.count + additional_claimants_csv_record_count
  end

  def has_multiple_claimants?
    claimant_count > 1
  end

  def remove_additional_claimants_csv!
    super.tap do
      update_columns(additional_claimants_csv_record_count: 0, additional_claimants_csv: nil)
    end
  end

  def remove_pdf!
    super.tap { update_column(:pdf, nil) }
  end

  def remove_claim_details_rtf!
    super.tap { update_column(:claim_details_rtf, nil) }
  end

  def submittable?
    %i<primary_claimant primary_respondent>.all? do |relation|
      send(relation).present?
    end
  end

  def fee_calculation
    ClaimFeeCalculator.calculate claim: self
  end

  def payment_applicable?
    Rails.logger.info "Claim #{self.id} #{self.application_reference} payment_applicable gw: #{PaymentGateway.available?} fee_to_pay? #{fee_to_pay?} fee_group_reference #{fee_group_reference?} "
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
    remove_pdf! if pdf_present?
    PdfFormBuilder.build(self) { |file| self.update pdf: file }
    create_event Event::PDF_GENERATED
  end

  def attachments
    self.class.uploaders.keys.map(&method(:send)).delete_if { |a| a.file.nil? }
  end

  def to_param
    self.application_reference
  end

  private

  def state_machine
    @state_machine ||= Claim::FiniteStateMachine.new(claim: self)
  end

  alias_method :setup_state_machine, :state_machine

  def generate_application_reference
    self.application_reference ||= unique_application_reference
  end

  def unique_application_reference
    loop do
      ref = ApplicationReference.generate
      return ref unless self.class.exists?(application_reference: ref)
    end
  end

  def respond_to_missing?(meth, include_private=false)
    if state_machine.respond_to?(meth)
      true
    else
      super
    end
  end

  def method_missing(meth, *args, &blk)
    if state_machine.respond_to? meth
      state_machine.send meth, *args, &blk
    else
      super
    end
  end
end
