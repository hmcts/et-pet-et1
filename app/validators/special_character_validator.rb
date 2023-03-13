class SpecialCharacterValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    return if value.nil?

    if attribute == :address_building
      special_chars = '\<>?.[]=)(*&£^%$#~{}+@!±§|"/:;`'
    else
      special_chars = '\<>.,?[]=)(*&£^%$#~{}+@!±§|"/:;`'
    end
    regex = /[#{special_chars.gsub(/./){|char| "\\#{char}"}}]/

    record.errors.add(attribute, :contains_special_characters) if value.match(regex)
  end
end
