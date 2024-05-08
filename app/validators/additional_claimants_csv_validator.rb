class AdditionalClaimantsCsvValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    return if record.send(attribute).blank?

    result = EtApi.validate_claimants_file(record, attribute, value)

    if result.valid?
      record.public_send("#{attribute}_record_count=", result.line_count)
    else
      add_errors(result, record, attribute)
    end
  end

  private

  def add_errors(result, record, attribute)
    result.errors.each do |e|
      next unless e.attribute == :base

      record.errors.add attribute, e.type.to_sym
    end
    line_errors = line_errors(record, result, attribute)
    record.errors.add attribute,
                      :invalid,
                      line_errors:
  end

  def line_errors(record, result, attribute)
    result.errors.each_with_object([]) do |e, acc|
      next if e.attribute == :base

      _, line_number, line_attribute = e.attribute.to_s.split('/').reject(&:blank?)
      prefix = I18n.t(error_prefix(record, attribute), line_number: line_number.to_i + 1)
      error_text = I18n.t(error_text(record, attribute, line_attribute, e), line_number:, **e.options)
      acc << "#{prefix} #{error_text}"
    end
  end

  def error_prefix(record, attribute)
    "#{error_attributes(record, attribute)}.row_prefix"
  end

  def error_text(record, attribute, line_attribute, error)
    "#{error_attributes(record, attribute)}.attributes.#{line_attribute}.#{error.type}"
  end

  def error_attributes(record, attribute)
    "activemodel.errors.models.#{record.class.model_name.i18n_key}.attributes.#{attribute}_row"
  end
end
