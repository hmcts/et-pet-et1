class Session < ActiveRecord::Base

  def to_h
    data.dup
  end

  # rubocop:disable Style/MethodMissing
  def method_missing(m, *args)
    if m.to_s.end_with?('=')
      data.merge!(m.to_s[0..-2] => args.first)
    else
      data[m.to_s]
    end
  end

  def respond_to?(*)
    true
  end
end
