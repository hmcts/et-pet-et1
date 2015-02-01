class Claim < ActiveRecord::Base
  include MemorableWord
  include CarrierwaveAttachments
  include BitmaskedComplaintsOutcomes

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

  delegate :amount, :created_at, :reference, :present?,
    to: :payment, prefix: true, allow_nil: true

  after_create -> { create_event Event::CREATED }

  after_initialize :setup_state_machine
  after_initialize :generate_application_reference

  delegate :destroy_all, :any?, to: :secondary_claimants, prefix: true

  before_update :secondary_claimants_destroy_all,
    if: :additional_claimants_csv_changed?

  before_update :remove_additional_claimants_csv!,
    if: :secondary_claimants_any?

  def self.find_by_reference(reference)
    find_by application_reference: ApplicationReference.normalize(reference)
  end

  def create_event(event, actor: 'app', message: nil)
    events.create event: event, actor: actor, message: message
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
    create_event Event::PDF_GENERATED
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

  delegate :fee_to_pay?, :application_fee, to: :fee_calculation

  private

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
