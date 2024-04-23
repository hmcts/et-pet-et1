class NullObject < BasicObject
  def method_missing(*)
    nil
  end

  def respond_to_missing?(_method_name, _include_private = false)
    true
  end

  def respond_to?(*)
    true
  end
end
