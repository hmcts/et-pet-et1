class ClaimantForm < Form
  ADDRESS_REGEXP      = /\Aaddress_/
  TITLES              = %i<mr mrs ms miss>.freeze
  GENDERS             = %i<male female>.freeze
  CONTACT_PREFERENCES = %i<email post fax>.freeze
  COUNTRIES           = %i<united_kingdom other>.freeze

  attributes :first_name, :last_name, :date_of_birth, :address_telephone_number,
             :mobile_number, :fax_number, :email_address, :special_needs,
             :title, :gender, :contact_preference, :address_building,
             :address_street, :address_locality, :address_county, :address_post_code, :address_country

  booleans   :has_special_needs, :has_representative

  validates :first_name, :last_name, :address_building, :address_street,
            :address_locality, :address_post_code, :address_county, presence: true

  validates :title, inclusion: { in: TITLES.map(&:to_s) }
  validates :gender, inclusion: { in: GENDERS.map(&:to_s) }
  validates :contact_preference, inclusion: { in: CONTACT_PREFERENCES.map(&:to_s) }
  validates :first_name, :address_locality, :address_county, length: { maximum: 25 }
  validates :last_name, length: { maximum: 100 }
  validates :address_building, :address_street, length: { maximum: 30 }
  validates :address_telephone_number, :mobile_number, :fax_number, length: { maximum: 15 }
  validates :address_post_code, length: { maximum: 8 }

  validates :fax_number,    presence: { if: -> { contact_preference.fax? } }
  validates :email_address, presence: { if: -> { contact_preference.email? } }

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
