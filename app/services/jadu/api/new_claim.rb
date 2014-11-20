require 'forwardable'
require 'jadu/api/request'

module Jadu
  class API
    class NewClaim
      extend Forwardable
      def_delegator :@api_request, :do

      def initialize(uri, xml, files, **options)
        params = string_params(xml) + file_params(files)
        @api_request = Jadu::API::Request.new(uri, params, **options)
      end

      private

      def string_params(xml)
        [Multipart::StringParam.new('new_claim', xml)]
      end

      def file_params(files)
        files.map { |name, content| Multipart::FileParam.new(name, name, content) }
      end
    end
  end
end
