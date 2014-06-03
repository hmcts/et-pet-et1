json.array!(@yourdetails) do |yourdetail|
  json.extract! yourdetail, :id, :title, :first_name, :last_name, :gender, :date_of_birth, :building_number_name, :street, :town_city, :county, :postcode, :telephone, :mobile, :contact_method, :disability, :help_with_fees, :reprasentative
  json.url yourdetail_url(yourdetail, format: :json)
end
