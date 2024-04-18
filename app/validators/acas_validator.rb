class AcasValidator < ActiveModel::EachValidator
  ACAS_FORMAT = %r{\A[a-zA-Z]{1,2}\d{6}/\d{2}/\d{2}\z}

  def validate_each(record, attribute, value)
    return unless value.present? && !value.match(ACAS_FORMAT)

    record.errors.add(attribute, :invalid)
  end
end
