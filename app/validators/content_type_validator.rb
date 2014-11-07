class ContentTypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    attachment = record.send(attribute)
    if attachment.present? && options[:in].exclude?(ContentType.of attachment)
       message = options[:message] || I18n.t('errors.messages.invalid')
       record.errors[attribute] << message
    end
  end
end
