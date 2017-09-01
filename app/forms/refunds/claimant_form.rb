module Refunds
  class ClaimantForm < Form
    TITLES               = %w[mr mrs miss ms].freeze
    GENDERS              = %w[male female prefer_not_to_say].freeze
    CONTACT_PREFERENCES  = %w[email post].freeze
    COUNTRIES            = %w[united_kingdom other].freeze
    EMAIL_ADDRESS_LENGTH = 100
    NAME_LENGTH          = 100

    include AddressAttributes.but_skip_postcode_validation
    include AgeValidator

    validates :address_post_code,
      post_code: true, length: { maximum: POSTCODE_LENGTH },
      unless: :international_address?
    boolean :is_claimant
    boolean :has_address_changed
    boolean :has_name_changed
    attribute :first_name,         String
    attribute :last_name,          String
    attribute :date_of_birth,      Date
    attribute :address_country,    String
    attribute :mobile_number,      String
    attribute :fax_number,         String
    attribute :email_address,      String
    attribute :title,              String
    attribute :national_insurance, String

    validates :title, :first_name, :last_name, :address_country, presence: true

    validates :title, inclusion: { in: TITLES }
    validates :first_name, :last_name, length: { maximum: NAME_LENGTH }
    validates :mobile_number, :fax_number, length: { maximum: PHONE_NUMBER_LENGTH }
    validates :address_country, inclusion: { in: COUNTRIES }
    validates :email_address, presence: true,
                              email: true,
                              length: { maximum: EMAIL_ADDRESS_LENGTH }

    dates :date_of_birth

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
  end
end
