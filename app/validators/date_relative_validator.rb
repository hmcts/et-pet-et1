class DateRelativeValidator < ActiveModel::EachValidator
  def initialize(in_the_past: nil, **kwargs)
    @in_the_past = in_the_past
    super(**kwargs)
  end

  def validate_each(record, attribute, value)
    if future_date?(value)
      record.errors.add(attribute, :less_than)
    end
  end

  private

  attr_reader :in_the_past

  def future_date?(value)
    return false if in_the_past.nil?
    time = Time.zone.today
    if value.is_a?(String)
      time < (Date.parse(value))
    elsif value.is_a?(Date) || value.is_a?(Time)
      time < (value)
    end
  end

end
