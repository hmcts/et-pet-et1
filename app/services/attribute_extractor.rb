class AttributeExtractor # :nodoc:
  def initialize(attributes={})
    @hash = attributes
  end

  def =~(regex)
    @hash.each_with_object({}) do |(attribute, value), hash|
      attribute = attribute.to_s

      next unless attribute =~ regex
      hash[attribute.sub(regex, '').to_sym] = value
    end
  end
end
