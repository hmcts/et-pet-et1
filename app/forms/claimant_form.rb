class ClaimantForm < Form
  TITLES               = ['mr', 'mrs', 'miss', 'ms'].freeze
  GENDERS              = ['male', 'female', 'prefer_not_to_say'].freeze
  CONTACT_PREFERENCES  = ['email', 'post'].freeze
  COUNTRIES            = ['united_kingdom', 'other'].freeze
  EMAIL_ADDRESS_LENGTH = 100
  NAME_LENGTH          = 100

  include AddressAttributes.but_skip_postcode_validation
  include AgeValidator

  validates :address_post_code,
    post_code: true, length: { maximum: POSTCODE_LENGTH },
    unless: :international_address?

  attribute :first_name,         :string
  attribute :last_name,          :string
  attribute :date_of_birth,      :gds_date_type
  attribute :address_country,    :string
  attribute :mobile_number,      :string
  attribute :fax_number,         :string
  attribute :email_address,      :string
  attribute :special_needs,      :string
  attribute :title,              :string
  attribute :gender,             :string
  attribute :contact_preference, :string

  boolean   :has_special_needs

  before_validation :reset_special_needs!, unless: :has_special_needs?

  validates :title, :gender, :first_name, :last_name, :address_country,
    :contact_preference, presence: true

  validates :title, inclusion: { in: TITLES }
  validates :gender, inclusion: { in: GENDERS }
  validates :first_name, :last_name, length: { maximum: NAME_LENGTH }
  validates :contact_preference, inclusion: { in: CONTACT_PREFERENCES }
  validates :mobile_number, :fax_number, length: { maximum: PHONE_NUMBER_LENGTH }
  validates :address_country, inclusion: { in: COUNTRIES }
  validates :fax_number,    presence: { if: :contact_preference_fax? }
  validates :email_address, presence: { if: :contact_preference_email? },
                            email: { if: :email_address? },
                            length: { maximum: EMAIL_ADDRESS_LENGTH }

  validate :older_then_16

  delegate :fax?, :email?, to: :contact_preference, prefix: true

  validates :date_of_birth, date: true

  def contact_preference
    (read_attribute(:contact_preference) || "").inquiry
  end

  def has_special_needs
    @has_special_needs ||= special_needs.present?
  end

  def target
    resource.primary_claimant || resource.build_primary_claimant
  end

  def first_name=(name)
    write_attribute :first_name, name.try(:strip)
  end

  def last_name=(name)
    write_attribute :last_name, name.try(:strip)
  end

  private

  def international_address?
    address_country != 'united_kingdom'
  end

  def reset_special_needs!
    self.special_needs = nil
  end
end
