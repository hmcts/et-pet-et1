class PostCodeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    postcode = UKPostcode.parse(value)

    record.errors.add(attribute, :invalid) unless postcode.valid? && postcode.full?
  end
end
