class Session < ApplicationRecord

  def to_h
    data.dup
  end

  def method_missing(method, *args)
    if method.to_s.end_with?('=')
      data.merge!(method.to_s[0..-2] => args.first)
    else
      data[method.to_s]
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    super || data.key?(method_name.to_s.delete_suffix('='))
  end

  def respond_to?(*)
    true
  end
end
