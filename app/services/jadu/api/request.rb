require 'multipart'

module Jadu
  class API
    class Request
      def initialize(uri, params, host: nil, **options)
        @uri = uri
        @params = params
        @host = host || uri.hostname
        @options = options.merge(use_ssl: @uri.scheme == 'https')
      end

      def perform
        req = Multipart::Post.new(@uri.path, *@params)
        req['Host'] = @host
        Net::HTTP.start(@uri.hostname, @uri.port, @options) { |http|
          http.request(req)
        }
      end
    end
  end
end
