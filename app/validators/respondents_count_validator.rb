class RespondentsCountValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.size > options[:maximum]
      record.errors.add(attribute, options[:message])
    end
  end
end
