class DateRangeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless range.cover?(value)
      record.errors.add(attribute, :date_range, start_date: start_date_str, end_date: end_date_str)
    end
  end

  private

  def start_date_str
    range.first.strftime(date_format)
  end

  def end_date_str
    range.last.strftime(date_format)
  end

  def range
    @range ||= options[:range]
  end

  def date_format
    @date_format ||= options[:format]
  end

end
