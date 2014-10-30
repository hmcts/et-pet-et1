class AdditionalClaimantsCsv::ErrorConversion < Struct.new(:header, :errors)
  def convert
    errors.messages.inject([]) { |acc, error| acc << humanize(error) }
  end

  private

  def mapped_attributes
    @mapped_attributes ||= Hash[AdditionalClaimantsCsv::ModelBuilder::ATTRIBUTES.zip header]
  end

  def humanize(error)
    error_field, error_message = error
    map_attribute_header = mapped_attributes[error_field]
    "#{map_attribute_header.strip} - #{error_message.first.strip}"
  end
end
