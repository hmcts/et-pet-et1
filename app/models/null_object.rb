class NullObject < BasicObject
  def method_missing(*)
    nil
  end

  def respond_to?(*)
    true
  end
end
