class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # Hash failed to be coerced into Date, e.g. invalid date
    # Empty String as D.O.B is optional field on CSV - this makes me v. sad!
    if value.is_a?(Hash) || is_non_empty_string?(value)
      record.errors.add(attribute)
    end
  end

  private def is_non_empty_string?(value)
    value.is_a?(String) && !value.blank?
  end
end
