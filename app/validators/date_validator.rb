class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    parts = 1.upto(3).map { |index| record.send("#{attribute}(#{index}i)") }

    if parts.any?(&:present?)
      parsed = Date.civil *parts.map(&:to_i) rescue nil
      record.errors.add attribute, I18n.t('errors.messages.invalid') unless parsed
    end
  end
end
