class SpecialCharacterValidator < ActiveModel::EachValidator
  REGEX = /^[a-zA-Z '-]+$/i.freeze

  def validate_each(record, attribute, value)
    return if value.nil?

    if allow_comma == true && allow_numbers == true
      regex = /^[a-zA-Z0-9 ,'-]+$/i
    elsif allow_comma == true
      regex = /^[a-zA-Z ,'-]+$/i
    elsif allow_numbers == true
      regex = /^[a-zA-Z0-9 '-]+$/i
    else
      regex = /^[a-zA-Z '-]+$/i
    end

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
