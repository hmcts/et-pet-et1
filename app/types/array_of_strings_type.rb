class ArrayOfStringsType < ActiveRecord::Type::Value
  def cast(value)
    if value.respond_to?(:map)
      value.map do |v|
        v.to_s
      end
    else
      value
    end
  end
end
