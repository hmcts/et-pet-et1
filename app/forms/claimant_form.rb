class ClaimantForm < Form
  TITLES               = %i<mr mrs ms miss>.freeze
  GENDERS              = %i<male female prefer_not_to_say>.freeze
  CONTACT_PREFERENCES  = %i<email post>.freeze
  COUNTRIES            = %i<united_kingdom other>.freeze
  EMAIL_ADDRESS_LENGTH = 100
  NAME_LENGTH          = 100

  include AddressAttributes

  attributes :first_name, :last_name, :date_of_birth, :address_country,
             :mobile_number, :fax_number, :email_address, :special_needs,
             :title, :gender, :contact_preference

  booleans   :has_special_needs

  date       :date_of_birth

  before_validation :reset_special_needs!, unless: :has_special_needs?

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
    (attributes[:contact_preference] || "").inquiry
  end

  def has_special_needs
    @has_special_needs ||= special_needs.present?
  end

  def has_representative
    @has_representative ||= resource.representative.present?
  end

  private

  def reset_special_needs!
    attributes[:special_needs] = nil
  end

  def target
    resource.primary_claimant || resource.build_primary_claimant
  end
end
