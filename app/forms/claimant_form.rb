class ClaimantForm < Form
  attributes :first_name, :last_name, :date_of_birth, :telephone_number,
             :mobile_number, :fax_number, :email_address, :special_needs,
             :title, :gender, :contact_preference  
end
