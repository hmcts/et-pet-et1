module Et1
  module Test
    module JsonObjects
      class Base
        def initialize(json)

          self.json = symbolize(json)

        end

        private

        def symbolize(json)
          case json
          when Array
            json.each {|node| symbolize(node)}
          when Hash
            json.deep_symbolize_keys!
          end
        end

        attr_accessor :json
      end
    end
  end
end
