class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # Hash failed to be coerced into Date, e.g. invalid date
    record.errors.add(attribute) if value.is_a? Hash
  end
end
