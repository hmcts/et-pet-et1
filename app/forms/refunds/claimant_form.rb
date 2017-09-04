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
      dup_attributes = {
        claimant_title: attrs[:title],
        claimant_first_name: attrs[:first_name],
        claimant_last_name: attrs[:last_name],
        claimant_national_insurance: attrs[:national_insurance],
        claimant_date_of_birth: attrs[:date_of_birth]
      }
      resource.assign_attributes(dup_attributes)
    end

    def international_address?
      address_country != 'united_kingdom'
    end
  end
end
