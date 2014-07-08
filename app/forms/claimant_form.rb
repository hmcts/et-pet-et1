class ClaimantForm < Form
  ADDRESS_REGEXP      = /\Aaddress_/
  TITLES              = %i<mr mrs ms miss>.freeze
  GENDERS             = %i<male female>.freeze
  CONTACT_PREFERENCES = %i<email post fax>.freeze

  attributes :first_name, :last_name, :date_of_birth, :address_telephone_number,
             :mobile_number, :fax_number, :email_address, :special_needs,
             :title, :gender, :contact_preference, :address_building,
             :address_street, :address_locality, :address_county, :address_post_code

  booleans   :has_special_needs, :has_representative

  def contact_preference
    ActiveSupport::StringInquirer.new(attributes[:contact_preference] || "")
  end

  def save
    if valid?
      extractor = AttributeExtractor.new(attributes)
      claimant  = resource.claimants.build(extractor =~ /\A(?!#{ADDRESS_REGEXP})/)
      address   = claimant.build_address(extractor =~ ADDRESS_REGEXP)

      resource.save
    end
  end
end
