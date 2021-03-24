class CcdAddressValidator < ActiveModel::EachValidator
  ADDRESS_LINE_LENGTH  = 50
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :invalid_ccd_address, count: ADDRESS_LINE_LENGTH) unless value.nil? || value.length <= ADDRESS_LINE_LENGTH
  end
end
