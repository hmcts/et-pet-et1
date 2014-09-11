class PostCodeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value
      postcode = UKPostcode.new(value)
      message  = options[:message] || I18n.t('errors.messages.invalid')

      record.errors[attribute] << message unless postcode.valid? && postcode.full?
    end
  end
end
