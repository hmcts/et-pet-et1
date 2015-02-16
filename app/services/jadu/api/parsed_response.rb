require 'forwardable'

module Jadu
  class API
    class ParsedResponse
      delegate :[], :values_at, to: :to_h

      def initialize(response)
        @response = response
      end

      def ok?
        @response.code.to_i / 100 == 2
      end

      def to_h
        @parsed_json ||= JSON.parse(@response.body)
      end
    end
  end
end
