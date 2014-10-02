class Form
  class MultiParameterDate < Struct.new(:target, :attribute)
    def [](index)
      store[index - 1]
    end

    def []=(index, value)
      store[index - 1] = value

      begin
        target.send "#{attribute}=", Date.parse(store.join '-')
      rescue ArgumentError
      end

      value
    end

    private def store
      @store ||= begin
        date  = target.send("#{attribute}")
        date ? date.to_s.split('-') : [nil, nil, nil]
      end
    end
  end
end
