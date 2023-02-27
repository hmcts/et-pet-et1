module AddressAttributes
  extend ActiveSupport::Concern

  ADDRESS_LINE_LENGTH  = 50
  PHONE_NUMBER_LENGTH  = 21
  POSTCODE_LENGTH      = 8

  included do
    include AddressAttributes.but_skip_postcode_validation
    validates :address_post_code, post_code: true, length: { maximum: POSTCODE_LENGTH }
  end

  # rubocop:disable Metrics/MethodLength
  def self.but_skip_postcode_validation
    Module.new do
      extend ActiveSupport::Concern

      const_set :ADDRESS_LINE_LENGTH, 50
      const_set :PHONE_NUMBER_LENGTH, 21
      const_set :POSTCODE_LENGTH,     8

      def skip_address_validation?
        false
      end

      included do
        attribute :address_building,         :string
        attribute :address_street,           :string
        attribute :address_locality,         :string
        attribute :address_county,           :string
        attribute :address_post_code,        :string
        attribute :address_telephone_number, :string

        validates :address_building, :address_street, :address_locality,
                  :address_county, :address_post_code, presence: true, unless: :skip_address_validation?

        validates :address_building, :address_street, :address_locality, :address_county, ccd_address: true,
                                                                                          unless: :skip_address_validation?
        validates :address_telephone_number, length: { maximum: PHONE_NUMBER_LENGTH }, ccd_phone: true,
                                             allow_blank: true, unless: :skip_address_validation?
      end
    end
  end
end
