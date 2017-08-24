class PdfForm::PrimaryClaimantPresenter < PdfForm::BaseDelegator
  GENDERS             = [:male, :female, :prefer_not_to_say].freeze
  CONTACT_PREFERENCES = [:email, :post].freeze

  def name
    first_name + ' ' + last_name
  end

  # rubocop:disable MethodLength
  # rubocop:disable Metrics/AbcSize
  def to_h
    {
      "1.1 title tick boxes" => title,
      "1.2 first names" => first_name,
      "1.3 surname" => last_name,
      "1.4 DOB day" => date_of_birth && ("%02d" % date_of_birth.day),
      "1.4 DOB month" => date_of_birth && ("%02d" % date_of_birth.month),
      "1.4 DOB year" => date_of_birth && date_of_birth.year.to_s,
      "1.4 gender" => use_or_off(gender, GENDERS),
      "1.5 number" => address_building,
      "1.5 street" => address_street,
      "1.5 town city" => address_locality,
      "1.5 county" => address_county,
      "1.5 postcode" => format_postcode(address_post_code),
      "1.6 phone number" => address_telephone_number,
      "1.7 mobile number" => mobile_number,
      "1.8 tick boxes" => use_or_off(contact_preference, CONTACT_PREFERENCES),
      "1.9 email" => email_address,

      "12.1 tick box" => tri_state(special_needs.present?),
      "12.1 if yes" => special_needs
    }
  end
  # rubocop:enable MethodLength
  # rubocop:enable Metrics/AbcSize
end
