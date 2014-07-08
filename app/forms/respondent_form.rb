class RespondentForm < Form
  NO_ACAS_REASON = %i<
    joint_claimant_has_acas_number
    acas_has_no_jurisdiction
    employer_contacted_acas
    interim_relief
    claim_against_security_or_intelligence_services
  >.freeze

  attributes :organisation_name, :name, :address_telephone_number,
             :address_building, :address_street, :address_locality, :address_county,
             :address_post_code, :work_address_building,
             :work_address_street, :work_address_locality,
             :work_address_county, :work_address_post_code,
             :work_address_telephone_number,
             :acas_early_conciliation_certificate_number,
             :no_acas_number_reason

  booleans   :worked_at_different_address, :was_employed, :no_acas_number

  def save
    if valid?
      extractor = AttributeExtractor.new(attributes)
      address_attributes = extractor =~ /\Aaddress_/
      work_address_attributes = extractor =~ /\Awork_address_/
      respondent_attributes = extractor =~ /\A(?!(work_)?address_)/

      respondent = resource.respondents.build \
        respondent_attributes.except(:worked_at_different_address, :no_acas_number)

      respondent.addresses.build address_attributes
      respondent.addresses.build work_address_attributes

      resource.save
    end
  end


end
