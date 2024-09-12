class ClaimantForm < Form
  TITLES                   = ['Mr', 'Mrs', 'Miss', 'Ms'].freeze
  GENDERS                  = ['male', 'female', 'prefer_not_to_say'].freeze
  CONTACT_PREFERENCES      = ['email', 'post'].freeze
  COUNTRIES                = ['united_kingdom', 'other'].freeze
  EMAIL_ADDRESS_LENGTH     = 100
  NAME_LENGTH              = 100
  EXTERNAL_POSTCODE_LENGTH = 14

  include AddressAttributes.but_skip_postcode_validation

  validates :address_post_code,
            post_code: true, length: { maximum: POSTCODE_LENGTH },
            unless: :international_address?
  validates :address_post_code, length: { maximum: EXTERNAL_POSTCODE_LENGTH }, if: :international_address?

  attribute :first_name,         :string
  attribute :last_name,          :string
  attribute :date_of_birth,      :et_date
  attribute :address_country,    :string
  attribute :mobile_number,      :string
  attribute :fax_number,         :string
  attribute :email_address,      :string
  attribute :special_needs,      :string
  attribute :title,              :string
  attribute :other_title,        :string
  attribute :gender,             :string
  attribute :contact_preference, :string
  attribute :allow_phone_or_video_attendance
  attribute :allow_phone_or_video_reason, :string
  attribute :has_special_needs, :boolean

  before_validation :reset_special_needs!, unless: :has_special_needs?
  before_validation :clear_email_address, unless: :contact_preference_email?
  before_validation :clean_empty_title

  validates :first_name, :last_name, :address_country,
            :contact_preference, presence: true
  validates :has_special_needs, inclusion: [true, false]

  validates :title, ccd_personal_title: true
  validates :other_title, presence: { if: :other_title_selected? }
  validates :gender, inclusion: { in: GENDERS }, allow_blank: true
  validates :first_name, :last_name, length: { maximum: NAME_LENGTH }, special_character: true
  validates :contact_preference, inclusion: { in: CONTACT_PREFERENCES }, ccd_claimant_contact_preference: true
  validates :mobile_number, :fax_number, length: { maximum: PHONE_NUMBER_LENGTH }, ccd_phone: true, allow_blank: true
  validates :address_country, inclusion: { in: COUNTRIES }
  validates :fax_number,    presence: { if: :contact_preference_fax? }
  validates :email_address, presence: { if: :contact_preference_email? },
                            email: { if: :contact_preference_email?, mode: :strict },
                            ccd_email: { if: :contact_preference_email? },
                            length: { maximum: EMAIL_ADDRESS_LENGTH }

  validates :date_of_birth, date: true, date_range: { range: -> { 100.years.ago..10.years.ago } }, allow_blank: true

  delegate :fax?, :email?, to: :contact_preference, prefix: true

  def allow_phone_or_video_attendance=(value)
    super(value&.reject(&:blank?))
  end

  def contact_preference
    (read_attribute(:contact_preference) || "").inquiry
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

  def other_title_selected?
    title == I18n.t("claims.personal_details.title.options.Other")
  end

  def international_address?
    address_country != 'united_kingdom'
  end

  def clean_empty_title
    self.title = nil if title == ''
  end

  def reset_special_needs!
    self.special_needs = nil
  end

  def clear_email_address
    self.email_address = nil
  end
end
