class AdditionalClaimantsCsv::ModelBuilder
  ATTRIBUTES = %i<title first_name last_name date_of_birth address_building
    address_street address_locality address_county address_post_code>.freeze

  def build(row_data)
    additional_claimant.tap do |form|
      form.assign_attributes attributes_from(row_data)
    end
  end

  private

  def additional_claimant
    @additional_claimant ||= AdditionalClaimantsForm::AdditionalClaimant.new(Claimant.new)
  end

  def attributes_from(row_data)
    Hash[ATTRIBUTES.zip(sanitize row_data)]
  end

  def sanitize(row_data)
    row_data.take(ATTRIBUTES.size).map { |value| value.strip.downcase if value }
  end
end
