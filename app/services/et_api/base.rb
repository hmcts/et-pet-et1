class EtApi
  class Base
    def initialize(base_url: ENV.fetch('ET_API_URL'), json_parser: JSON)
      self.base_url = base_url
      self.json_parser = json_parser
    end

    def call(claim)
      raise "Must be implemented in the sub class"
    end

    private

    attr_accessor :base_url, :json_parser

    def raise_on_response_code(response)
      case response.code
      when 200, 201, 202, 0 then return
      when 422 then raise UnprocessableEntity.new('Unprocessible entity', response.body)
      when 400 then raise BadRequest.new('Bad request', response.body)
      when 500 then raise InternalServerError.new('Internal server error', response.body)
      else raise UnknownResponse.new("An unknown response code of #{response.code} was returned from the api", response.body)
      end
    end

    def raise_on_return_code(response)
      case response.return_code
      when nil, :ok, 0 then return
      when :operation_timedout then raise Timeout, 'Timeout'
      else raise UnknownResponse.new("Unknown response return code - #{response.return_code}", response.body)
      end
    end

    def send_request(json, path:, subject:)
      log_json(json, url: "#{base_url}#{path}", subject: subject)

      request = Typhoeus::Request.new "#{base_url}#{path}",
        verbose: true, method: :post, body: json,
        headers: { 'Accept': 'application/json', 'Content-Type': 'application/json' }
      perform_requests(request)
      response = request.response

      log_response(response)
      raise_on_response_code(response)
      raise_on_return_code(response)
      response
    end

    def perform_requests(request)
      hydra.queue(request)
      hydra.run
    end

    def hydra
      @hydra ||= Typhoeus::Hydra.new max_concurrency: 1
    end

    def log_json(json, url:, subject:)
      pretty_json = JSON.pretty_generate(JSON.parse(json))
      Rails.logger.info "Sent #{subject} to API at #{url} - json was #{pretty_json}"
    end

    def log_response(response)
      Rails.logger.info "API Responded with status #{response.code}, a return code of #{response.return_code} and a body of #{response.body}"
    end

  end
end
