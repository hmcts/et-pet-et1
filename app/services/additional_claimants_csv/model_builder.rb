class AdditionalClaimantsCsv::ModelBuilder
  ATTRIBUTES = [
    :title, :first_name, :last_name, :date_of_birth,
    :address_building, :address_street, :address_locality, :address_county,
    :address_post_code
  ].freeze

  def build_form_claimant(row_data)
    assign_attributes(claimant_form, row_data)
  end

  def build_claimant(row_data)
    assign_attributes(Claimant.new, row_data)
  end

  private

  def assign_attributes(model, row_data)
    model.tap { |m| m.assign_attributes attributes_from(row_data) }
  end

  def claimant_form
    @claimant_form ||= AdditionalClaimantsForm::AdditionalClaimant.new(Claimant.new)
  end

  def attributes_from(row_data)
    Hash[ATTRIBUTES.zip(sanitize(row_data))]
  end

  def sanitize(row_data)
    check_csv_dob_format(row_data) if ATTRIBUTES.include?(:date_of_birth)
    row_data.take(ATTRIBUTES.size).map { |value| value.strip.downcase if value }
  end

  def check_csv_dob_format(row_data)
    dob = row_data[ATTRIBUTES.index(:date_of_birth)]
    return if /(\D*-)/.match(dob).blank?
    raise CsvDobValidationError
  end
end
