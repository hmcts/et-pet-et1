class CcdPhoneValidator < ActiveModel::EachValidator
  REGEX = /^(((\+44\s?\d{4}|\(?0\d{4}\)?)\s?\d{3}\s?\d{3})|((\+44\s?\d{3}|\(?0\d{3}\)?)\s?\d{3}\s?\d{4})|((\+44\s?\d{2}|\(?0\d{2}\)?)\s?\d{4}\s?\d{4}))(\s?#(\d{4}|\d{3}))?$/
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :invalid_ccd_phone) unless value =~ REGEX
  end
end
