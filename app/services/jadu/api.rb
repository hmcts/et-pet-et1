require 'jadu/api/et_office'
require 'jadu/api/new_claim'
require 'jadu/api/parsed_response'

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
end
