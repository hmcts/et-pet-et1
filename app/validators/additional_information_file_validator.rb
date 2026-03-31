class AdditionalInformationFileValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    result = EtApi.validate_additional_information_file(record, attribute, value)
    return if result.valid?

    add_errors(record, attribute, result)
  end

  private

  def add_errors(record, attribute, result)
    result.errors.each do |error|
      record.errors.add(attribute, error.type.to_sym, **error.options)
    end
  end
end
