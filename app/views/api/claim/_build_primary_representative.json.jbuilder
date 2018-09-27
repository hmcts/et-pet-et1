json.uuid SecureRandom.uuid
json.command 'BuildPrimaryRepresentative'
json.data do
  json.name representative.name
  json.organisation_name representative.organisation_name
  representative.address.tap do |a|
    json.address_attributes do
      json.building a.try(:building)
      json.street a.try(:street)
      json.locality a.try(:locality)
      json.county a.try(:county)
      json.post_code a.try(:post_code)
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
