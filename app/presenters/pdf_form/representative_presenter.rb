class PdfForm::RepresentativePresenter < PdfForm::BaseDelegator
  CONTACT_PREFERENCES = [:email, :post].freeze

  # rubocop:disable MethodLength
  def to_h
    {
      "11.3 postcode" => format_postcode(address_post_code),
      "11.1" => name,
      "11.2" => organisation_name,
      "11.3 number" => address_building,
      "11.3 street" => address_street,
      "11.3 town city" => address_locality,
      "11.3 county" => address_county,
      "11.4 dx number" => dx_number,
      "11.5 phone number" => address_telephone_number,
      "11.6 mobile number" => mobile_number,
      # TODO: "11.7 reference" => reference,
      "11.8 email" => email_address,
      "11.9 tick boxes" => use_or_off(contact_preference, CONTACT_PREFERENCES)
    }
  end
  # rubocop:enable MethodLength
end
