class AcasValidator < ActiveModel::EachValidator
  ACAS_FORMAT = /\A[a-zA-Z]{1,2}[\d]{6}\/[\d]{2}\/[\d]{2}\z/

  def validate_each(record, attribute, value)
    if value.present?
      record.errors.add(attribute, :invalid) unless value.match(ACAS_FORMAT)
    end
  end
end
