class AdditionalClaimantsCsvValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    if record.send(attribute).present?
      result = AdditionalClaimantsCsv::Validator.new(record).validate

      if result.success
        record.public_send("#{attribute}_record_count=", result.line_count)
      else
        record.errors[:erroneous_line_number] = "#{result.error_line}"
        result.errors.each { |e| record.errors[attribute] << e }
      end
    end
  end
end
