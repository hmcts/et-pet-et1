class ClaimantForm < Form
  TITLES              = %i<mr mrs ms miss>.freeze
  GENDERS             = %i<male female prefer_not_to_say>.freeze
  CONTACT_PREFERENCES = %w<email post fax>.freeze
  COUNTRIES           = %i<united_kingdom other>.freeze

  include AddressAttributes

  attributes :first_name, :last_name, :date_of_birth, :address_country,
             :mobile_number, :fax_number, :email_address, :special_needs,
             :title, :gender, :contact_preference,
             :applying_for_remission

  booleans   :has_special_needs, :has_representative

  validates :title, :gender, :first_name, :last_name, :address_country, :contact_preference, presence: true

  validates :title, inclusion: { in: TITLES.map(&:to_s) }
  validates :gender, inclusion: { in: GENDERS.map(&:to_s) }
  validates :first_name, :last_name, length: { maximum: NAME_LENGTH }
  validates :contact_preference, inclusion: { in: CONTACT_PREFERENCES.map(&:to_s) }
  validates :mobile_number, :fax_number, length: { maximum: PHONE_NUMBER_LENGTH }
  validates :address_country, inclusion: { in: COUNTRIES.map(&:to_s) }
  validates :fax_number,    presence: { if: -> { contact_preference.fax? } }
  validates :email_address, presence: { if: -> { contact_preference.email? } }, length: { maximum: EMAIL_ADDRESS_LENGTH }

  def contact_preference
    ActiveSupport::StringInquirer.new(attributes[:contact_preference] || "")
  end

  def has_special_needs
    @has_special_needs ||= special_needs.present?
  end

  def has_representative
    @has_representative ||= resource.representative.present?
  end

  private def target
    resource.claimants.first || resource.claimants.build
  end
end
