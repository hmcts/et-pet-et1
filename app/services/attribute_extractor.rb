class AttributeExtractor # :nodoc:
  def initialize(attributes={})
    @hash = attributes
  end

  def =~(regex)
    @hash.inject({}) do |hash, (attribute, value)|
      attribute = attribute.to_s

      if attribute =~ regex
        hash.update attribute.sub(regex, '').to_sym => value
      else
        hash
      end
    end
  end
end
