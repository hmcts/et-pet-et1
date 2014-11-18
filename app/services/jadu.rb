require 'multipart'
require 'forwardable'

module Jadu
  class API
    def initialize(base_url, **options)
      @base_uri = URI.parse(base_url)
      @options = options
    end

    def new_claim(xml, files = {})
      parse(NewClaim.new(merge_uri('new-claim'), xml, files, **@options))
    end

    def fgr_et_office(postcode)
      parse(ETOffice.new(merge_uri('fgr-et-office'), postcode, **@options))
    end

    private

    def merge_uri(partial_path)
      @base_uri.merge(partial_path)
    end

    def parse(request)
      ParsedResponse.new(request.do)
    end
  end

  class ParsedResponse
    extend Forwardable

    def_delegator :to_h, :[]

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

  class APIRequest
    def initialize(uri, params, host: nil, **options)
      @uri = uri
      @params = params
      @host = host || uri.hostname
      @options = options.merge(use_ssl: @uri.scheme == 'https')
    end

    def do
      req = Multipart::Post.new(@uri.path, *@params)
      req['Host'] = @host
      Net::HTTP.start(@uri.hostname, @uri.port, @options) { |http|
        http.request(req)
      }
    end
  end

  class ETOffice
    extend Forwardable
    def_delegator :@api_request, :do

    def initialize(uri, postcode, **options)
      params = [Multipart::StringParam.new('postcode', postcode)]
      @api_request = APIRequest.new(uri, params, **options)
    end
  end

  class NewClaim
    extend Forwardable
    def_delegator :@api_request, :do

    def initialize(uri, xml, files, **options)
      params = string_params(xml) + file_params(files)
      @api_request = APIRequest.new(uri, params, **options)
    end

    private

    def string_params(xml)
      [Multipart::StringParam.new('new_claim', xml)]
    end

    def file_params(files)
      files.map { |name, content|
        Multipart::FileParam.new(name, name, content)
      }
    end
  end
end
