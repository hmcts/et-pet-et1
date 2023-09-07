class SpecialCharacterValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    return if value.nil? || value.blank?

    regex = if allow_comma == true && allow_numbers == true
              /^[a-zA-Z0-9 ,'-]+$/i
            elsif allow_comma == true
              /^[a-zA-Z ,'-]+$/i
            elsif allow_numbers == true
              /^[a-zA-Z0-9 '-]+$/i
            else
              /^[a-zA-Z '-]+$/i
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
