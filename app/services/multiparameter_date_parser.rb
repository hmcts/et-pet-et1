class MultiparameterDateParser
  class << self
    def parse(attributes)
      new(attributes).parse
    end
  end

  REGEX = /\A(?<param>\w+)\((?<index>\d)i\)\Z/

  attr_reader :attributes

  def initialize(attributes)
    @attributes = attributes.dup
  end

  def parse
    memo   = Hash.new { |hash, key| hash[key] = [] }
    values = attributes.reduce(memo) do |memo, (key, _)|
      if match_data = key.match(REGEX)
        param, index = match_data.captures
        memo[param][index.to_i-1] = attributes.delete(key).to_i
      end
      memo
    end

    values = values.map do |key, value|
      begin
        value = Date.civil(*value)
      rescue ArgumentError
        value = nil
      end

      [key, value]
    end

    attributes.update Hash[values]
  end
end
