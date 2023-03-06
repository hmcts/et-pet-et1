# @TODO This class can be much simpler once we are not worrying about values being hashes,
# strings etc.. (once all forms are converted to NullDbForm)
class DateValidator < ActiveModel::EachValidator
  def initialize(options, &block)
    my_options = options.dup
    @omit_day = my_options.delete(:omit_day)
    super(my_options, &block)
  end

  def validate_each(record, attribute, value)
    if illegal_date?(record, attribute)
      record.errors.add(attribute, :invalid)
    elsif illegal_year?(value)
      record.errors.add(attribute, :invalid)
    elsif coercion_failed?(value, attribute, record) || non_empty_string?(value, attribute, record)
      record.errors.add(attribute, :invalid)
    end
  end

  private

  attr_reader :omit_day

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
    return false if value.nil?

    case value
    when String
      Date.parse(value).year < 1000
    when Date, Time
      value.year < 1000
    else
      value[1].present? && value[1].to_i < 1000
    end
  rescue ArgumentError
    false
  end

  def illegal_date?(record, attribute)
    # The date type in rails seems a bit basic in terms of validation - it will accept 31/2/xxxx but not 32/2/xxxx,
    #   neither of which should be valid so we are going to validate better here.
    value = read_attribute_before_type_cast(record, attribute, default: nil)
    if value.is_a?(Hash) && value.values.all?(&:present?)
      Date.new(value[1], value[2], value[3] || (omit_day ? 1 : nil))
      false
    elsif value.is_a?(String) && value.blank?
      false
    elsif value.is_a?(String)
      Date.parse(value)
      false
    elsif value.is_a?(Date) || value.is_a?(Time)
      false
    elsif value.nil?
      false
    else
      true
    end
  rescue Date::Error, TypeError
    true
  end

  def read_attribute_before_type_cast(record, attribute, default:)
    return default unless record.respond_to?(:read_attribute_before_type_cast)

    record.read_attribute_before_type_cast(attribute)
  end
end
