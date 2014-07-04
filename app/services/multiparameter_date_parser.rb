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
    values = attributes.each_with_object(memo) do |(key, _), memo|
      next unless match_data = key.match(REGEX)
      param, index = match_data.captures
      memo[param][index.to_i-1] = attributes.delete(key).to_i
    end

    attributes.update values.map { |k,v| [k, (Date.civil *v rescue nil)] }.to_h
  end
end
