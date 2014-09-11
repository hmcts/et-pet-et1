module AddressAttributes
  extend ActiveSupport::Concern

  included do
    attributes :address_building, :address_street, :address_locality,
      :address_county, :address_post_code, :address_telephone_number

    validates :address_building, :address_street, :address_locality,
      :address_county, :address_post_code, presence: true

    validates :address_building, length: { maximum: Form::ADDRESS_LINE_LENGTH }
    validates :address_street, length: { maximum: Form::ADDRESS_LINE_LENGTH }
    validates :address_locality, :address_county, length: { maximum: Form::LOCALITY_LENGTH }
    validates :address_post_code, post_code: true, length: { maximum: Form::POSTCODE_LENGTH }
    validates :address_telephone_number, length: { maximum: Form::PHONE_NUMBER_LENGTH }
  end
end
