class Claim < ActiveRecord::Base
  has_secure_password validations: false

  has_one :primary_claimant,   class_name: 'Claimant'
  has_one :primary_respondent, class_name: 'Respondent'

  has_many :claimants, dependent: :destroy
  has_many :respondents, dependent: :destroy
  has_one  :representative, dependent: :destroy
  has_one  :employment, dependent: :destroy
  has_one  :office, dependent: :destroy
  has_one  :payment

  delegate :amount, :created_at, :reference, :present?, to: :payment, prefix: true, allow_nil: true

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
    PaymentGateway.available? &&
    fee_calculation.fee_to_pay? &&
    fee_group_reference?
  end

  def remission_applicable?
    fee_calculation.application_fee != fee_calculation.application_fee_after_remission
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
