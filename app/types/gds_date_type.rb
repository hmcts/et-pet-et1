class GdsDateType < ActiveRecord::Type::Date
  def cast(value)
    super(pre_process(value))
  end

  def deserialize(value)
    cast(value)
  end

  private

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
