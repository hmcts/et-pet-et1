class CcdEmailValidator < ActiveModel::EachValidator
  REGEX = /^([a-zA-Z0-9_\-.]+)@([a-zA-Z0-9_\-.]+)\.([a-zA-Z]{2,5})$/
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :invalid_ccd_email) unless value.nil? || value =~ REGEX
  end
end
