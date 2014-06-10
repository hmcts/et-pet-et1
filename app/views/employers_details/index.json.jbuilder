json.array!(@employers_details) do |employers_detail|
  json.extract! employers_detail, :id, :name, :building_name_number, :street, :town_city, :county, :postcode, :telephone, :acas_certificate_number, :acas_number, :work_address_different, :another_employer_same_case, :employed_by_organisation
  json.url employers_detail_url(employers_detail, format: :json)
end
