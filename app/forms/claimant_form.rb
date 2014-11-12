class ClaimantForm < Form
  TITLES               = %w<mr mrs miss ms>.freeze
  GENDERS              = %w<male female prefer_not_to_say>.freeze
  CONTACT_PREFERENCES  = %w<email post>.freeze
  COUNTRIES            = %w<united_kingdom other>.freeze
  EMAIL_ADDRESS_LENGTH = 100
  NAME_LENGTH          = 100

  include AddressAttributes

  attribute :first_name,         String
  attribute :last_name,          String
  attribute :date_of_birth,      Date
  attribute :address_country,    String
  attribute :mobile_number,      String
  attribute :fax_number,         String
  attribute :email_address,      String
  attribute :special_needs,      String
  attribute :title,              String
  attribute :gender,             String
  attribute :contact_preference, String

  boolean   :has_special_needs

  before_validation :reset_special_needs!, unless: :has_special_needs?

  validates :title, :gender, :first_name, :last_name, :address_country, :contact_preference, presence: true

  validates :title, inclusion: { in: TITLES }
  validates :gender, inclusion: { in: GENDERS }
  validates :first_name, :last_name, length: { maximum: NAME_LENGTH }
  validates :contact_preference, inclusion: { in: CONTACT_PREFERENCES }
  validates :mobile_number, :fax_number, length: { maximum: PHONE_NUMBER_LENGTH }
  validates :address_country, inclusion: { in: COUNTRIES }
  validates :fax_number,    presence: { if: -> { contact_preference.fax? } }
  validates :email_address, presence: { if: -> { contact_preference.email? } }, length: { maximum: EMAIL_ADDRESS_LENGTH }

  dates :date_of_birth

  def contact_preference
    (super || "").inquiry
  end

  def has_special_needs
    @has_special_needs ||= special_needs.present?
  end

  def target
    resource.primary_claimant || resource.build_primary_claimant
  end

  private

  def reset_special_needs!
    self.special_needs = nil
  end
end
