class AdditionalClaimantsCsvValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if record.send(attribute).present?

      result = EtApi.validate_claimants_file(record, attribute, value)

      if result.valid?
        record.public_send("#{attribute}_record_count=", result.line_count)
      else
        add_errors(result, record, attribute)
      end
    end
  end

  private

  def add_errors(result, record, attribute)
    result.errors.each do |e|
      next unless e.attribute == :base

      record.errors.add attribute, e.type.to_sym
    end
    line_errors = result.errors.each_with_object([]) do |e, acc|
      next if e.attribute == :base

      _, line_number, line_attribute = e.attribute.to_s.split('/').reject(&:blank?)
      prefix = I18n.t(
        "activemodel.errors.models.#{record.class.model_name.i18n_key}.attributes.#{attribute}_row.row_prefix", line_number: line_number.to_i + 1
      )
      error_text = I18n.t(
        "activemodel.errors.models.#{record.class.model_name.i18n_key}.attributes.#{attribute}_row.attributes.#{line_attribute}.#{e.type}", line_number:, **e.options
      )
      acc << "#{prefix} #{error_text}"
    end
    record.errors.add attribute,
                      :invalid,
                      line_errors:
  end
end
