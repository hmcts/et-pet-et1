json.uuid SecureRandom.uuid
json.command 'BuildPrimaryRepresentative'
json.data do
  json.name representative.name
  json.organisation_name representative.organisation_name
  representative.address.tap do |a|
    if a.nil? || a.empty?
      json.address_attributes({})
    else
      json.address_attributes do
        json.building a.building
        json.street a.street
        json.locality a.locality
        json.county a.county
        json.post_code a.post_code
      end
    end
  end

  json.address_telephone_number representative.address_telephone_number
  json.mobile_number representative.mobile_number
  # @TODO Use I18n for this below
  json.representative_type RepresentativeType.convert_for_jadu(representative.type)
  json.dx_number representative.dx_number
  json.reference nil
  json.contact_preference nil
  json.email_address representative.email_address
  json.fax_number nil
end
