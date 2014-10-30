require 'csv'

class AdditionalClaimantsCsv::Validator < Struct.new(:csv_path)
  CSV_HEADERS = ["Title", "First name", "Last name", "Date of birth",
    "Building number or name", "Street", "Town/city", "County", "Postcode"].freeze

  def validate
    AdditionalClaimantsCsv::Result.new.tap do |result|
      each_row_with_index do |row, index|

        validate_headers(row.headers) if index.zero?

        result.line_count = index.next
        model = model_builder.build(row.fields)

        next if model.valid?

        errors = humanized_errors(row.headers, model.errors)
        result.fail(errors)
        break
      end
    end
  rescue CSV::MalformedCSVError
    return malformed_csv_error
  end

  def model_builder
    @model_builder ||= AdditionalClaimantsCsv::ModelBuilder.new
  end

  private

  def each_row_with_index(&_block)
    CSV.open(csv_path, headers: true) do |csv|
      csv.each_with_index { |row, index| yield row, index }
    end
  end

  def validate_headers(header)
    raise CSV::MalformedCSVError unless header == CSV_HEADERS
  end

  def humanized_errors(row_header, row_errors)
    AdditionalClaimantsCsv::ErrorConversion.new(row_header, row_errors).convert
  end

  def malformed_csv_error
    AdditionalClaimantsCsv::Result.new.tap do |result|
      result.fail([I18n.t("claims.additional_claimants_upload.malformatted_csv")])
    end
  end
end
