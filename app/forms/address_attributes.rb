module AddressAttributes
  extend ActiveSupport::Concern

  included do
    attributes :address_building, :address_street, :address_locality,
      :address_county, :address_post_code, :address_telephone_number

    def self.validates_address(obj)
      obj.validates :address_building, :address_street, :address_locality,
        :address_county, :address_post_code, presence: true

      obj.validates :address_building, length: { maximum: Form::ADDRESS_LINE_LENGTH }
      obj.validates :address_street, length: { maximum: Form::ADDRESS_LINE_LENGTH }
      obj.validates :address_locality, :address_county, length: { maximum: Form::LOCALITY_LENGTH }
      obj.validates :address_post_code, post_code: true, length: { maximum: Form::POSTCODE_LENGTH }
      obj.validates :address_telephone_number, length: { maximum: Form::PHONE_NUMBER_LENGTH }
    end
  end
end
