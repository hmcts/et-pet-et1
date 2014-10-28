class Jadu::RespondentSerializer < Jadu::BaseSerializer
  present :address

  ACAS_NO_REASON_CODE_MAPPING = {
    'joint_claimant_has_acas_number' => 'other_claimant',
    'acas_has_no_jurisdiction' => 'outside_acas',
    'employer_contacted_acas' => 'employer_contacted_acas',
    'interim_relief' => 'interim_relief',
    'claim_against_security_or_intelligence_services' => 'claim_targets'
  }.freeze

  def exemption_code(reason)
    ACAS_NO_REASON_CODE_MAPPING[reason]
  end

  def to_xml(options={})
    xml = options[:builder] ||= ::Builder::XmlMarkup.new(indent: options[:indent])
    xml.Respondent do
      xml.GroupContact primary_respondent?
      xml.Name name
      address.to_xml(options)
      xml.OfficeNumber address_telephone_number
      xml.PhoneNumber work_address_telephone_number
      xml.Acas do
        xml.Number acas_early_conciliation_certificate_number
        xml.ExemptionCode exemption_code(no_acas_number_reason)
      end
    end
  end
end
