module Refunds
  class ApplicantForm < Form
    TITLES               = %w[mr mrs miss ms].freeze
    GENDERS              = %w[male female prefer_not_to_say].freeze
    CONTACT_PREFERENCES  = %w[email post].freeze
    COUNTRIES            = %w[united_kingdom other].freeze
    EMAIL_ADDRESS_LENGTH = 100
    NAME_LENGTH          = 100

    attribute :address_building,         String
    attribute :address_street,           String
    attribute :address_locality,         String
    attribute :address_county,           String
    attribute :address_post_code,        String
    attribute :address_telephone_number, String

    validates :address_building, :address_street,
              :address_post_code, presence: true

    validates :address_building, :address_street, length: { maximum: AddressAttributes::ADDRESS_LINE_LENGTH }
    validates :address_locality, :address_county, length: { maximum: AddressAttributes::LOCALITY_LENGTH }
    validates :address_telephone_number, length: { maximum: AddressAttributes::PHONE_NUMBER_LENGTH }

    include AgeValidator

    validates :address_post_code,
      post_code: true, length: { maximum: AddressAttributes::POSTCODE_LENGTH },
      unless: :international_address?
    boolean :is_claimant
    boolean :has_name_changed
    attribute :first_name,         String
    attribute :last_name,          String
    attribute :date_of_birth,      Date
    attribute :address_country,    String
    attribute :email_address,      String
    attribute :title,              String

    validates :title, :first_name, :last_name, :address_country, presence: true

    validates :title, inclusion: { in: TITLES }
    validates :first_name, :last_name, length: { maximum: NAME_LENGTH }
    validates :address_country, inclusion: { in: COUNTRIES }
    validates :email_address, allow_blank: true,
                              email: true,
                              length: { maximum: EMAIL_ADDRESS_LENGTH }
    validates :address_telephone_number, presence: true
    validates :date_of_birth, presence: true
    validates :has_name_changed, nil: true

    dates :date_of_birth

    def first_name=(name)
      super name.try :strip
    end

    def last_name=(name)
      super name.try :strip
    end

    def save
      if valid?
        run_callbacks :save do
          ActiveRecord::Base.transaction do
            target.update_attributes attributes unless target.frozen?
            clone_claimant_details
            resource.save
          end
        end
      else
        false
      end
    end

    private

    def clone_claimant_details
      attrs = target.attributes.with_indifferent_access
      new_claim_attributes = {
        claimant_name: "#{attrs[:applicant_title].titleize} #{attrs[:applicant_first_name]} #{attrs[:applicant_last_name]}"
      }
      resource.assign_attributes(new_claim_attributes)
    end

    def international_address?
      address_country != 'united_kingdom'
    end
  end
end
