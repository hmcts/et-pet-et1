class DateRangeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless range.cover?(value)
      record.errors.add(attribute, :date_range, start_date: range.first.strftime(date_format), end_date: range.last.strftime(date_format))
    end
  end

  private

  def range
    @range ||= options[:range]
  end

  def date_format
    @date_format ||= options[:format]
  end

end
