module AddressAttributes
  extend ActiveSupport::Concern

  ADDRESS_LINE_LENGTH  = 75
  LOCALITY_LENGTH      = 25
  PHONE_NUMBER_LENGTH  = 21
  POSTCODE_LENGTH      = 8

  included do
    attribute :address_building,         String
    attribute :address_street,           String
    attribute :address_locality,         String
    attribute :address_county,           String
    attribute :address_post_code,        String
    attribute :address_telephone_number, String

    validates :address_building, :address_street, :address_locality,
      :address_county, :address_post_code, presence: true

    validates :address_building, :address_street, length: { maximum: ADDRESS_LINE_LENGTH }
    validates :address_locality, :address_county, length: { maximum: LOCALITY_LENGTH }
    validates :address_post_code, post_code: true, length: { maximum: POSTCODE_LENGTH }
    validates :address_telephone_number, length: { maximum: PHONE_NUMBER_LENGTH }
  end
end
