class PastDateValidator < ActiveModel::EachValidator
  def validate_each(record, attr_name, value)
    record.errors.add(attr_name, :past_date, options) if value.is_a?(Date) && (value > Time.zone.today)
  end
end
