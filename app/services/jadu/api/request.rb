require 'multipart'

module Jadu
  class API
    class Request
      HTTP_TIMEOUT_OPTIONS = {
        open_timeout: ENV.fetch('HTTP_OPEN_TIMEOUT_S').to_i,
        read_timeout: ENV.fetch('HTTP_READ_TIMEOUT_S').to_i }

      def initialize(uri, params, host: nil, **options)
        @uri = uri
        @params = params
        @host = host || uri.hostname
        @options = options.merge(use_ssl: @uri.scheme == 'https').
                     merge(HTTP_TIMEOUT_OPTIONS)
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
