class CsvDobValidationError < StandardError
end

class AdditionalClaimantsCsv::Validator < AdditionalClaimantsCsv::BaseCsv
  CSV_HEADERS = [
    "Title", "First name", "Last name", "Date of birth",
    "Building number or name", "Street", "Town/city", "County", "Postcode"
  ].freeze

  def validate
    AdditionalClaimantsCsv::Result.new.tap do |result|
      iterate_over_csv_collection(result)
    end
  rescue CSV::MalformedCSVError
    return malformed_csv_error
  rescue CsvDobValidationError
    return validation_csv_dob_error
  end

  private

  def iterate_over_csv_collection(result)
    csv_collection.each_with_index do |row, index|

      validate_headers(row.headers) if index.zero?

      result.line_count = index.next
      model = model_builder.build_form_claimant(row.fields)

      next if model.valid?

      errors = humanized_errors(row.headers, model.errors)
      result.fail(errors)
      break
    end
  end

  def validate_headers(headers)
    raise CSV::MalformedCSVError unless headers == CSV_HEADERS
  end

  def humanized_errors(row_headers, row_errors)
    AdditionalClaimantsCsv::ErrorConversion.new(row_headers, row_errors).convert
  end

  def malformed_csv_error
    AdditionalClaimantsCsv::Result.new.tap do |result|
      result.fail([I18n.t("claims.additional_claimants_upload.malformatted_csv")])
    end
  end

  def validation_csv_dob_error
    AdditionalClaimantsCsv::Result.new.tap do |result|
      result.fail([I18n.t("claims.additional_claimants_upload.dob_info")])
    end
  end
end
