class RespondentForm < Form
  attributes :type, :organisation_name, :name, :telephone_number,
             :mobile_number, :email_address, :dx_number, :address_building,
             :address_street, :address_locality, :address_county,
             :address_post_code, :second_address_building,
             :second_address_street, :second_address_locality,
             :second_address_county, :second_address_post_code,
             :acas_early_conciliation_certificate_number, :no_acas_number_reason

end
