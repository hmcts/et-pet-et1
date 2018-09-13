# @TODO This class can be much simpler once we are not worrying about values being hashes, strings etc.. (once all forms are converted to NullDbForm)
class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if coercion_failed?(value, attribute, record) || non_empty_string?(value, attribute, record) || illegal_year?(value)
      record.errors.add(attribute)
    end
  end

  private

  # @TODO This will not need to check for a hash once all forms are converted to the NullDbForm
  def coercion_failed?(value, attribute, record)
    # Hash failed to be coerced into Date, e.g. invalid date
    original_value = read_attribute_before_type_cast(record, attribute, default: value)
    (value.nil? && original_value.is_a?(Hash) && original_value.values.any?(&:present?)) || value.is_a?(Hash)
  end



  def non_empty_string?(value, attribute, record)
    # Strings can be passed in the date field when uploading a CSV
    # An empty string should not be flagged as an error

    # TODO: CSV Date validation should be handled separately
    original_value = read_attribute_before_type_cast(record, attribute, default: value)
    (value.nil? && original_value.is_a?(String) && original_value.present?) || (value.is_a?(String) && value.present?)
  end

  def illegal_year?(value)
    # Needs to verify that four digits are given for a year
    value.is_a?(Date) && value.year < 1_000
  end

  def read_attribute_before_type_cast(record, attribute, default:)
    return default unless record.respond_to?(:read_attribute_before_type_cast)
    record.read_attribute_before_type_cast(attribute)
  end
end
