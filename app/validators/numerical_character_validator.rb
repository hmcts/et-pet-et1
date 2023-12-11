class NumericalCharacterValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    return if value.nil?

    record.errors.add(attribute, :contains_numerical_characters) if value =~ /\d/
  end

end
