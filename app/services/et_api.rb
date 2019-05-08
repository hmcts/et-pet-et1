class EtApi
  def self.create_claim(*args)
    new.create_claim(*args)
  end

  def self.build_diversity_response(*args)
    new.build_diversity_response(*args)
  end

  def create_claim(claim, uuid: SecureRandom.uuid)
    json = ApplicationController.render 'api/claim/create_claim.json.jbuilder', locals: {
      claim: claim, office: claim.office, employment: claim.employment, uuid: uuid
    }
    send_request(json, path: '/claims/build_claim', subject: 'claim')
  end

  def build_diversity_response(diversity_response, uuid: SecureRandom.uuid)
    json = ApplicationController.render 'api/diversity/build_diversity_response.json.jbuilder', locals: {
      response: diversity_response, uuid: uuid
    }
    send_request(json, path: '/diversity/build_diversity_response', subject: 'diversity_response')
  end

  class BaseException < RuntimeError
    def initialize(msg, response)
      super(msg)
      self.response = response
    end

    def retry?
      true
    end

    private

    attr_accessor :response
  end

  class UnprocessableEntity < BaseException
    def retry?
      false
    end
  end

  class InternalServerError < BaseException

  end

  class BadRequest < BaseException
    def retry?
      false
    end
  end

  class Timeout < BaseException
    def initialize(msg)
      super(msg, '{}')
    end
  end

  class UnknownResponse < BaseException

  end

  private

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

  def send_request(json, api_base: ENV.fetch('ET_API_URL'), path:, subject:)
    log_json(json, url: "#{api_base}#{path}", subject: subject)

    request = Typhoeus::Request.new "#{api_base}#{path}",
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
