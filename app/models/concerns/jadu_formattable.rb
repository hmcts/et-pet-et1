module JaduFormattable
  extend ActiveSupport::Concern

  ACAS_NO_REASON_CODE_MAPPING = {
    'joint_claimant_has_acas_number' => 'other_claimant',
    'acas_has_no_jurisdiction' => 'outside_acas',
    'employer_contacted_acas' => 'employer_contacted_acas',
    'interim_relief' => 'interim_relief',
    'claim_against_security_or_intelligence_services' => 'claim_targets'
  }.freeze

  def timestamp
    Time.zone.now
  end

  def case_type(claim)
    claim.claimant_count == 1 ? 'Single' : 'Multiple'
  end

  def jurisdiction(claim)
    claim.other_claim_details.present? ? 2 : 1
  end

  def remission_indicated(claim)
    claim.remission_claimant_count > 0 ? 'Indicated' : 'NotRequested'
  end

  def exemption_code(reason)
    ACAS_NO_REASON_CODE_MAPPING[reason]
  end

  def building_split(building)
    @building_split ||= building.strip.scan(/(^[0-9]{0,4})(.*)/).flatten
  end

  def address_number(building)
    number = building_split(building)[0]
    number.present? ? number.to_i : nil
  end

  def address_name(building)
    building_split(building)[1].strip
  end
end
