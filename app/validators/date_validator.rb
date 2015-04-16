class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if coercion_failed?(value) || non_empty_string?(value) || illegal_year?(value)
      record.errors.add(attribute)
    end
  end

  private

  def coercion_failed?(value)
    # Hash failed to be coerced into Date, e.g. invalid date
    value.is_a?(Hash)
  end

  def non_empty_string?(value)
    # Strings can be passed in the date field when uploading a CSV
    # An empty string should not be flagged as an error

    # TODO: CSV Date validation should be handled separately
    value.is_a?(String) && value.present?
  end

  def illegal_year?(value)
    # Needs to verify that four digits are given for a year
    value.is_a?(Date) && value.year < 1_000
  end
end
