class GdsDateType < ActiveRecord::Type::Date

  private

  def value_from_multiparameter_assignment(value)
    if value.is_a?(Hash)
      super 1 => value['year'], 2 => value['month'], 3 => value['day']
    else
      super
    end
  end
end
