class NullObject < BasicObject
  # rubocop:disable Style/MethodMissing
  def method_missing(*)
    nil
  end

  def respond_to?(*)
    true
  end
  # rubocop:enable Style/MethodMissing
end
