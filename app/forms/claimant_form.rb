class ClaimantForm < Form
  TITLES               = %w<mr mrs miss ms>.freeze
  GENDERS              = %w<male female prefer_not_to_say>.freeze
  CONTACT_PREFERENCES  = %w<email post>.freeze
  COUNTRIES            = %w<united_kingdom other>.freeze
  EMAIL_ADDRESS_LENGTH = 100
  NAME_LENGTH          = 100

  include AddressAttributes.but_skip_postcode_validation

  validates :address_post_code,
    post_code: true, length: { maximum: POSTCODE_LENGTH },
    unless: :international_address?

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
  validates :fax_number,    presence: { if: :contact_preference_fax? }
  validates :email_address, presence: { if: :contact_preference_email? },
    email: { if: :email_address? }, length: { maximum: EMAIL_ADDRESS_LENGTH }

  validate :older_then_16

  delegate :fax?, :email?, to: :contact_preference, prefix: true

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

  def first_name=(name)
    super name.try :strip
  end

  def last_name=(name)
    super name.try :strip
  end

  private

  def international_address?
    address_country != 'united_kingdom'
  end

  def reset_special_needs!
    self.special_needs = nil
  end

  def older_then_16
    return if self.date_of_birth.blank? || !self.date_of_birth.is_a?(Date)

    if self.date_of_birth.to_datetime.to_i >= 16.years.ago.to_i
      message = I18n.t('activemodel.errors.models.claimant.attributes.date_of_birth.too_young')
      errors.add(:date_of_birth, message)
    end
  end
end
