class ContentTypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    file = record.send(attribute)

    return unless file.present? && options[:in].exclude?(file['content_type'])

    message = options[:message] || I18n.t('errors.messages.invalid')
    record.errors.add(attribute, message)
  end
end
