class ClaimantForm < Form
  ADDRESS_REGEXP      = /\Aaddress_/
  TITLES              = %i<mr mrs ms miss>.freeze
  GENDERS             = %i<male female>.freeze
  CONTACT_PREFERENCES = %i<email post fax>.freeze

  attributes :first_name, :last_name, :date_of_birth, :address_telephone_number,
             :mobile_number, :fax_number, :email_address, :special_needs,
             :title, :gender, :contact_preference, :address_building,
             :address_street, :address_locality, :address_county, :address_post_code

  validates :first_name, :last_name, :address_building, :address_street,
            :address_locality, :address_post_code, presence: true

  validates :title, inclusion: { in: TITLES.map(&:to_s) }
  validates :gender, inclusion: { in: GENDERS.map(&:to_s) }
  validates :contact_preference, inclusion: { in: CONTACT_PREFERENCES.map(&:to_s) }
  validates :first_name, :address_locality, :address_county, length: { maximum: 25 }
  validates :last_name, length: { maximum: 100 }
  validates :address_building, :address_street, length: { maximum: 30 }
  validates :address_telephone_number, :mobile_number, :fax_number, length: { maximum: 15 }
  validates :address_post_code, length: { maximum: 8 }

  def assign_attributes(attributes={})
    date_of_birth_keys = attributes.keys.grep /\Adate_of_birth\(\di\)\Z/
    date_of_birth_attributes = attributes.values_at *date_of_birth_keys.sort

    valid_attributes = attributes.except(*date_of_birth_keys)

    if date_of_birth_attributes
      valid_attributes.merge date_of_birth: Date.civil(*date_of_birth_attributes.map(&:to_i))
    end

    super valid_attributes
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
