class GdsDateType < ActiveRecord::Type::Date
  def cast(value)
    post_process super(pre_process(value))
  end

  def deserialize(value)
    cast(value)
  end

  private

  def post_process(value)
    return value unless value.is_a?(Date)
    return value if value.year > 99
    Date.new(value.year + 1900, value.month, value.day)
  end

  def pre_process(value)
    value = from_params(value)
    value = pre_process_date_hash(value) if value.is_a?(Hash)
    value
  end

  def from_params(value)
    if value.respond_to?(:permitted?)
      value.to_unsafe_hash
    else
      value
    end
  end

  def pre_process_date_hash(value)
    return nil if value.values.all?(&:empty?)
    value = value.symbolize_keys
    return nil if value[:year].to_i.zero?
    value[:year] = "19#{value[:year]}" if value[:year].is_a?(String) && value[:year].to_i < 100
    value
  end

  def value_from_multiparameter_assignment(value)
    if value.is_a?(Hash)
      value = value.stringify_keys if value.respond_to?(:stringify_keys)
      begin
        super 1 => value['year'], 2 => value['month'], 3 => value['day']
      rescue ArgumentError
        value
      end
    else
      super
    end
  end
end
