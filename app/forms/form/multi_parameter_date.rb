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

    class << self
      def decorate object, attribute
        define_collaborator_on object, attribute

        1.upto(3) do |index|
          define_getter_on object, attribute, index
          define_setter_on object, attribute, index
        end
      end

      private

      def define_collaborator_on(object, attribute)
        object.send(:define_method, :"#{attribute}_date_params") do
          iv = :"@#{attribute}_date_collaborator"
          instance_variable_get(iv) || instance_variable_set(iv, MultiParameterDate.new(self, attribute))
        end
      end

      def define_getter_on(object, attribute, index)
        object.send(:define_method, :"#{attribute}(#{index}i)") do
          send(:"#{attribute}_date_params")[index]
        end
      end

      def define_setter_on(object, attribute, index)
        object.send(:define_method, :"#{attribute}(#{index}i)=") do |value|
          send(:"#{attribute}_date_params")[index] = value
        end
      end
    end
  end
end
