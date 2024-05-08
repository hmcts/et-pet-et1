class DxStringValidator < ActiveModel::EachValidator

  REGEX = /^[0-9a-zA-Z ,.-]+$/i

  def validate_each(record, attribute, value)
    record.errors.add(attribute, :invalid_dx) unless value.nil? || value =~ REGEX
  end
end
