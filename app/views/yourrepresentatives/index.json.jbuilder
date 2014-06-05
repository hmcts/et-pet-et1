json.array!(@yourrepresentatives) do |yourrepresentative|
  json.extract! yourrepresentative, :id, :type_of_representative, :representative_organisation, :representative_name, :building_number_name, :street, :town_city, :county, :postcode, :telephone, :mobile, :email, :dx_number
  json.url yourrepresentative_url(yourrepresentative, format: :json)
end
