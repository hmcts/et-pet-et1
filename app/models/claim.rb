class Claim < ActiveRecord::Base
  include PaymentAndFee
  include Reference
  include ClaimLists

  has_secure_password validations: false
  mount_uploader :claim_details_rtf,          AttachmentUploader
  mount_uploader :additional_claimants_csv,   AttachmentUploader
  mount_uploader :pdf,                        ClaimPdfUploader

  after_create { create_event Event::CREATED }

  has_one :primary_claimant, -> { where primary_claimant: true },
    class_name: 'Claimant'

  has_one :primary_respondent, -> { where primary_respondent: true },
    class_name: 'Respondent'

  has_many :secondary_claimants, -> { where primary_claimant: false },
    class_name: 'Claimant'

  has_many :secondary_respondents, -> { where primary_respondent: false },
    class_name: 'Respondent'

  has_many :events

  has_many :claimants, dependent: :destroy
  has_many :respondents, -> { order(created_at: :asc) }, dependent: :destroy
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
    message: I18n.t(
      'activemodel.errors.models.claim.attributes.secondary_respondents.too_many',
      max: Rails.application.config.additional_respondents_limit
    )
  }

  bitmask :discrimination_claims, as: DISCRIMINATION_COMPLAINTS
  bitmask :pay_claims,            as: PAY_COMPLAINTS
  bitmask :desired_outcomes,      as: DESIRED_OUTCOMES

  after_initialize :setup_state_machine
  after_initialize :generate_application_reference

  delegate :destroy_all, :any?, to: :secondary_claimants, prefix: true

  before_update :secondary_claimants_destroy_all,
    if: :additional_claimants_csv_changed?

  before_update :remove_additional_claimants_csv!,
    if: :secondary_claimants_any?

  def remove_additional_claimants_csv!
    super.tap do
      update_columns(additional_claimants_csv_record_count: 0, additional_claimants_csv: nil)
    end
  end

  def create_event(event, actor: 'app', message: nil)
    events.create event: event, actor: actor, message: message
  end

  def authenticate(password)
    password_digest? && super
  end

  def claimant_count
    claimants.count + additional_claimants_csv_record_count
  end

  def multiple_claimants?
    claimant_count > 1
  end

  def submittable?
    %i[primary_claimant primary_respondent].all? do |relation|
      send(relation).present?
    end
  end

  def attachments
    self.class.uploaders.keys.map(&method(:send)).delete_if { |a| a.file.nil? }
  end

  def generate_pdf!
    remove_pdf! if pdf_present?
    PdfFormBuilder.build(self) { |file| update pdf: file }
    create_event Event::PDF_GENERATED
  end

  def remove_pdf!
    super.tap { update_column(:pdf, nil) }
  end

  def remove_claim_details_rtf!
    super.tap { update_column(:claim_details_rtf, nil) }
  end

  private

  def state_machine
    @state_machine ||= Claim::FiniteStateMachine.new(claim: self)
  end

  alias setup_state_machine state_machine

  def respond_to_missing?(meth, include_private = false)
    return true if state_machine.respond_to?(meth)
    super
  end

  def method_missing(meth, *args, &blk)
    if state_machine.respond_to? meth
      state_machine.send meth, *args, &blk
    else
      super
    end
  end
end
