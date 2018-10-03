class EtApi
  def self.create_claim(*args)
    new.create_claim(*args)
  end

  def self.create_reference(*args)
    new.create_reference(*args)
  end

  def create_claim(claim, uuid: SecureRandom.uuid)
    json = ApplicationController.render 'api/claim/create_claim.json.jbuilder', locals: {
      claim: claim, office: claim.office, employment: claim.employment, uuid: uuid
    }
    send_request(json, path: '/claims/build_claim', subject: 'claim')
  end

  def create_reference(postcode:, uuid: SecureRandom.uuid)
    json = ApplicationController.render 'api/reference/create_reference.json.jbuilder', locals: {
      post_code: postcode, uuid: uuid
    }
    response = send_request(json, path: '/references/create_reference', subject: 'reference')
    JSON.parse(response.body)['data'].deep_symbolize_keys
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

  private

  def raise_on_response(response)
    case response.code
    when 422 then raise UnprocessableEntity.new('Unprocessible entity', response.body)
    when 400 then raise BadRequest.new('Bad request', response.body)
    when 500 then raise InternalServerError.new('Internal server error', response.body)

    end
  end

  def send_request(json, api_base: ENV.fetch('ET_API_URL'), path:, subject:)
    log_json(json, url: "#{api_base}#{path}", subject: subject)

    response = HTTParty.post "#{api_base}#{path}",
      body: json,
      headers: { 'Accept': 'application/json', 'Content-Type': 'application/json' }
    log_response(response)
    raise_on_response(response)
    response
  rescue ::Net::OpenTimeout
    raise Timeout, 'Timeout'
  end

  def log_json(json, url:, subject:)
    pretty_json = JSON.pretty_generate(JSON.parse(json))
    Rails.logger.info "Sent #{subject} to API at #{url} - json was #{pretty_json}"
  end

  def log_response(response)
    Rails.logger.info "API Responded with status #{response.code} and a body of #{response.body}"
  end
end
