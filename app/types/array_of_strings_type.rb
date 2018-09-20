class ArrayOfStringsType < ActiveRecord::Type::Value
  def cast(value)
    if value.respond_to?(:map)
      value.map(&:to_s)
    else
      value
    end
  end
end
