class Jadu::ClaimantSerializer < Jadu::BaseSerializer
  present :address

  def to_xml(options={})
    xml = builder(options)
    xml.Claimant do
      xml.GroupContact primary_claimant?
      xml.Title title
      xml.Forename first_name
      xml.Surname last_name
      address.to_xml(options)
      xml.OfficeNumber address_telephone_number
      xml.AltPhoneNumber mobile_number
      xml.Email email_address
      xml.Fax fax_number
      xml.PreferredContactMethod contact_preference.humanize
    end
  end
end
