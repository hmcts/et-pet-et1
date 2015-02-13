require 'forwardable'

module Jadu
  class API
    class ParsedResponse
      extend Forwardable

      def_delegators :to_h, :values_at, :[]

      def initialize(response)
        @response = response
      end

      def ok?
        @response.code.to_i / 100 == 2
      end

      def to_h
        @parsed_json ||= JSON.parse(@response.body)
      end

      alias_method :to_hash, :to_h
    end
  end
end
