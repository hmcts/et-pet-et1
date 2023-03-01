class Session < ApplicationRecord

  def to_h
    data.dup
  end

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
