class Claim < ActiveRecord::Base
  has_secure_password validations: false

  has_many :claimants
  has_many :respondents
  has_one  :representative
  has_one  :employment

  DISCRIMINATION_COMPLAINTS = %i<sex_including_equal_pay disability race age
    pregnancy_or_maternity religion_or_belief sexual_orientation
    marriage_or_civil_partnership gender_reassignment>.freeze
  PAY_COMPLAINTS = %i<redundancy notice holiday arrears other>.freeze
  DESIRED_OUTCOMES = %i<compensation_only tribunal_recommendation
    reinstated_employment_and_compensation new_employment_and_compensation>.freeze

  bitmask :discrimination_claims, as: DISCRIMINATION_COMPLAINTS
  bitmask :pay_claims,            as: PAY_COMPLAINTS
  bitmask :desired_outcomes,      as: DESIRED_OUTCOMES

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

  def primary_claimant
    claimants.first
  end

  def primary_respondent
    respondents.first
  end

  class << self
    def find_by_reference(reference)
      find KeyObfuscator.new.unobfuscate(reference)
    end
  end
end
