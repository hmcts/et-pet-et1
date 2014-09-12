class Claim < ActiveRecord::Base
  include JaduFormattable

  has_secure_password validations: false
  mount_uploader :attachment, AttachmentUploader

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
  delegate :file, to: :attachment, prefix: true

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

  def alleges_discrimination_or_unfair_dismissal?
    discrimination_claims.any? || is_unfair_dismissal?
  end

  def reference
    KeyObfuscator.new.obfuscate(id)
  end

  def claimant_count
    claimants.count
  end

  def remission_claimant_count
    claimants.where(applying_for_remission: true).count
  end

  # TODO validate claim against JADU XSD
  def submittable?
    %i<primary_claimant primary_respondent>.all? do |relation|
      send(relation).present?
    end
  end

  def fee_calculation
    ClaimFeeCalculator.calculate claim: self
  end

  def payment_applicable?
    false
  end

  def remission_applicable?
    fee_calculation.application_fee != fee_calculation.application_fee_after_remission
  end

  def to_xml(options={})
    require 'builder'
    xml = options[:builder] ||= ::Builder::XmlMarkup.new(indent: options[:indent])
    xml.instruct! unless options[:skip_instruct]
    xml.ETFeesEntry(
      'xmlns' => "http://www.justice.gov.uk/ETFEES",
      'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
      'xsi:noNamespaceSchemaLocation' => "ETFees_v0.09.xsd") do
      xml.DocumentID do
        xml.DocumentName 'ETFeesEntry'
        xml.UniqueID created_at.to_s(:number)
        xml.DocumentType 'ETFeesEntry'
        xml.TimeStamp timestamp.to_s(:xml)
        xml.Version 1
      end
      xml.FeeGroupReference fee_group_reference
      xml.SubmissionURN id
      xml.CurrentQuantityOfClaimants claimant_count
      xml.SubmissionChannel 'Web'
      xml.CaseType case_type(self)
      xml.Jurisdiction jurisdiction(self)
      xml.OfficeCode  office.code
      xml.DateOfReceiptET submitted_at
      xml.RemissionIndicated remission_indicated(self)
      xml.Administrator('xsi:nil'=>"true")
    end
  end

  class << self
    def find_by_reference(reference)
      find_by_id KeyObfuscator.new.unobfuscate(reference)
    end
  end

  private def state_machine
    @state_machine ||= Claim::FiniteStateMachine.new(claim: self)
  end

  alias :setup_state_machine :state_machine

  delegate *Claim::FiniteStateMachine.instance_methods, to: :state_machine
end
