module AddressAttributes
  def self.included(base)
    base.send :attributes, :address_building,
      :address_street,
      :address_locality,
      :address_county,
      :address_post_code,
      :address_telephone_number

    base.send :validates, :address_building,
      :address_street,
      :address_locality,
      :address_county,
      :address_post_code,
      presence: true


    base.send :validates, :address_building, length: { maximum: Form::ADDRESS_LINE_LENGTH }
    base.send :validates, :address_street, length: { maximum: Form::ADDRESS_LINE_LENGTH }
    base.send :validates, :address_locality, :address_county, length: { maximum: Form::TOWN_COUNTY_LENGTH }
    base.send :validates, :address_post_code, length: { maximum: Form::POSTCODE_LENGTH }
    base.send :validates, :address_telephone_number, length: { maximum: Form::PHONE_NUMBER_LENGTH }
  end
end
