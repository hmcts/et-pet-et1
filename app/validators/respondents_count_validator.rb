class RespondentsCountValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.size > options[:maximum]
      record.errors[attribute] << options[:message]
    end
  end
end
