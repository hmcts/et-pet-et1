class CcdPostCodeValidator < ActiveModel::EachValidator
  REGEX = /^([A-PR-UWYZ0-9][A-HK-Y0-9][AEHMNPRTVXY0-9]?[ABEHMNPRVWXY0-9]?{1,2}[0-9][ABD-HJLN-UW-Z]{2}|GIR0AA)$/
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :invalid_ccd_post_code) if value.nil? || REGEX.match(value.upcase.gsub(' ', '')).nil?
  end
end
