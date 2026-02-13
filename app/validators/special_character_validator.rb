class SpecialCharacterValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    return if value.nil?

    allowed_values = ["a-zA-Z '\\-/"]
    allowed_values << "0-9" if allow_numbers == true
    allowed_values << "," if allow_comma == true

    regex = Regexp.new("\\A[#{allowed_values.join}]+\\z", Regexp::IGNORECASE)

    record.errors.add(attribute, :contains_special_characters) unless value.match(regex)
  end

  private

  def allow_comma
    @allow_comma ||= options[:comma]
  end

  def allow_numbers
    @allow_numbers ||= options[:number]
  end
end
