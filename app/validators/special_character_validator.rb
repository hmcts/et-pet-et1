class SpecialCharacterValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    return if value.nil?

    if allow_comma == true
      special_chars = '\<>?.[]=)(*&£^%$#~{}+@!±§|"/:;`'
    else
      special_chars = '\<>.,?[]=)(*&£^%$#~{}+@!±§|"/:;`'
    end
    regex = /[#{special_chars.gsub(/./){|char| "\\#{char}"}}]/

    record.errors.add(attribute, :contains_special_characters) if value.match(regex)
  end

  private

  def allow_comma
    @allow_comma ||= options[:comma]
  end
end
