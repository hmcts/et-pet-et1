require 'forwardable'
require 'jadu/api/request'

module Jadu
  class API
    class ETOffice
      extend Forwardable
      def_delegator :@api_request, :do

      def initialize(uri, postcode, **options)
        params = [Multipart::StringParam.new('postcode', postcode)]
        @api_request = Jadu::API::Request.new(uri, params, **options)
      end
    end
  end
end
