class DateRangeValidator < ActiveModel::EachValidator
  def initialize(**kwargs)
    super(**kwargs)
  end

  def validate_each(record, attribute, value)
    unless value.nil?
      unless range.cover?(value)
        if date_format.nil?
          record.errors.add(attribute, :out_of_range)
        else
          record.errors.add(attribute, :date_range, start_date: start_date_str, end_date: end_date_str)
        end
      end
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
    @range ||= options[:range].respond_to?(:call) ? options[:range].call : options[:range]
  end

  def date_format
    @date_format ||= options[:format]
  end

end
