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

    parsed_dates = Hash[values.map { |key, value| [key, Date.civil(*value)] }]

    attributes.update parsed_dates
  end
end
