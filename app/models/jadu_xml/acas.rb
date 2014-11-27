module JaduXml
  class Acas < Struct.new(:respondent)
    ACAS_NO_REASON_CODE_MAPPING = {
      "joint_claimant_has_acas_number"                  => "other_claimant",
      "acas_has_no_jurisdiction"                        => "outside_acas",
      "employer_contacted_acas"                         => "employer_contacted_acas",
      "interim_relief"                                  => "interim_relief",
      "claim_against_security_or_intelligence_services" => "claim_targets"
    }.freeze

    delegate :acas_early_conciliation_certificate_number,
      :no_acas_number_reason, to: :respondent

    def exemption_code
      ACAS_NO_REASON_CODE_MAPPING[no_acas_number_reason]
    end
  end
end
