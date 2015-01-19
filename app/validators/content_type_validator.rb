class ContentTypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    attachment = record.send(attribute)

    return if already_attached_to_model?(attachment)

    if attachment.present? && options[:in].exclude?(ContentType.of attachment)
      message = options[:message] || I18n.t('errors.messages.invalid')
      record.errors[attribute] << message
    end
  end

  private def already_attached_to_model?(attachment)
    attachment.is_a? BaseUploader
  end
end
