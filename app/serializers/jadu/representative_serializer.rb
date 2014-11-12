class Jadu::RepresentativeSerializer < Jadu::BaseSerializer
  present :address

  def to_xml(options={})
    xml = builder(options)
    xml.Representative do
      xml.Name name
      address.to_xml(options)
      xml.OfficeNumber address_telephone_number
      xml.AltPhoneNumber mobile_number
      xml.Email email_address
      xml.ClaimantOrRespondent 'C'
    end
  end
end
