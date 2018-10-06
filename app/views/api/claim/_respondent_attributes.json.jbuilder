json.name respondent.name
json.contact nil
respondent.address.tap do |a|
  json.address_attributes do
    json.building a.try(:building)
    json.street a.try(:street)
    json.locality a.try(:locality)
    json.county a.try(:county)
    json.post_code a.try(:post_code)
  end
end

respondent.work_address.tap do |a|
  json.work_address_attributes do
    json.building a.try(:building)
    json.street a.try(:street)
    json.locality a.try(:locality)
    json.county a.try(:county)
    json.post_code a.try(:post_code)
  end
end
json.address_telephone_number respondent.address_telephone_number
json.work_address_telephone_number respondent.work_address_telephone_number
# @TODO Look at removing this one below - duplicate and was there because of JADU before
json.alt_phone_number respondent.work_address_telephone_number
json.acas_certificate_number respondent.acas_early_conciliation_certificate_number
json.acas_exemption_code respondent.no_acas_number_reason
# @TODO - The attributes below came from ET3 - maybe these are extended attributes for a respondent ?
json.dx_number nil
json.contact_preference nil
json.email_address nil
json.fax_number nil
json.organisation_employ_gb nil
json.organisation_more_than_one_site nil
json.employment_at_site_number nil
json.disability nil
json.disability_information nil
