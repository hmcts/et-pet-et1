module Refunds
  class ApplicantForm < Form
    TITLES               = ['mr', 'mrs', 'miss', 'ms'].freeze
    GENDERS              = ['male', 'female', 'prefer_not_to_say'].freeze
    CONTACT_PREFERENCES  = ['email', 'post'].freeze
    EMAIL_ADDRESS_LENGTH = 100
    NAME_LENGTH          = 100

    attribute :address_building,         String
    attribute :address_street,           String
    attribute :address_locality,         String
    attribute :address_county,           String
    attribute :address_post_code,        String
    attribute :address_telephone_number, String
    attribute :is_claimant,              Boolean
    attribute :has_name_changed,         Boolean

    validates :address_building, :address_street,
      :address_post_code, presence: true

    validates :address_building, :address_street, length: { maximum: AddressAttributes::ADDRESS_LINE_LENGTH }
    validates :address_locality, :address_county, length: { maximum: AddressAttributes::LOCALITY_LENGTH }
    validates :address_telephone_number, length: { maximum: AddressAttributes::PHONE_NUMBER_LENGTH }

    include AgeValidator

    validates :address_post_code,
      length: { maximum: AddressAttributes::POSTCODE_LENGTH }
    attribute :first_name,         String
    attribute :last_name,          String
    attribute :date_of_birth,      Date
    attribute :email_address,      String
    attribute :title,              String

    validates :title, :first_name, :last_name, presence: true

    validates :title, inclusion: { in: TITLES }
    validates :first_name, :last_name, length: { maximum: NAME_LENGTH }
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
  end
end
