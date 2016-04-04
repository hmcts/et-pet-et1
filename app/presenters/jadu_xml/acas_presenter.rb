module JaduXml
  class AcasPresenter < XmlPresenter
    NO_ACAS_REASONS_MAPPING = {
      "joint_claimant_has_acas_number" => "other_claimant",
      "acas_has_no_jurisdiction"       => "outside_acas",
      "employer_contacted_acas"        => "employer_contacted_acas",
      "interim_relief"                 => "interim_relief"
    }.freeze

    property :acas_early_conciliation_certificate_number, as: "Number"
    property :exemption_code, as: "ExemptionCode", exec_context: :decorator

    delegate :acas_early_conciliation_certificate_number, :no_acas_number_reason,
      to: :represented

    def exemption_code
      NO_ACAS_REASONS_MAPPING[no_acas_number_reason]
    end
  end
end
