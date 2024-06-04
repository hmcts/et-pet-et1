# @TODO Send as simple value and transform at presentation layer ?
json.title claimant.title.try(:titleize)
json.first_name claimant.first_name
json.last_name claimant.last_name
claimant.address.tap do |a|
  json.address_attributes do
    json.building a.building
    json.street a.street
    json.locality a.locality
    json.county a.county
    json.post_code a.post_code
    json.country({ 'united_kingdom' => "United Kingdom", "other" => "Outside United Kingdom" }[a.country])
  end
end
json.address_telephone_number claimant.address_telephone_number
json.mobile_number claimant.mobile_number
json.fax_number claimant.fax_number
json.email_address claimant.email_address
# @TODO Maybe send as simple value and transform at presentation layer ?
json.contact_preference claimant.contact_preference.try(:humanize)
json.allow_video_attendance claimant.allow_video_attendance
# @TODO Maybe send as simple value and transform at presentation layer ?
json.gender({ 'male' => 'Male', 'female' => 'Female', 'prefer_not_to_say' => 'N/K' }[claimant.gender])
json.date_of_birth claimant.date_of_birth
json.special_needs claimant.special_needs
