class AdditionalClaimantsCsvValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, _value)
    if record.send(attribute).present?

      if result(record).success
        record.public_send("#{attribute}_record_count=", @result.line_count)
      else
        add_errors(record, attribute)
      end
    end
  end

  private

  def result(record)
    @result = AdditionalClaimantsCsv::Validator.new(record).validate
  end

  def add_errors(record, attribute)
    record.errors.add(:erroneous_line_number, @result.error_line.to_s)
    @result.errors.each { |e| record.errors.add(attribute, e) }
  end
end
