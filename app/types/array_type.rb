class ArrayType < ActiveRecord::Type::Value
  def cast(value)
    value
  end
end
