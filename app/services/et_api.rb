class EtApi
  def self.create_claim(*args)
    new.create_claim(*args)
  end

  def self.create_reference(*args)
    new.create_reference(*args)
  end

  def create_claim(claim, api_base: ENV.fetch('ET_API_URL'), uuid: SecureRandom.uuid)
    json = ApplicationController.render 'api/claim/create_claim.json.jbuilder', locals: {
      claim: claim, office: claim.office, employment: claim.employment, uuid: uuid
    }
    Rails.logger.info "Sent claim to API at #{api_base}/claims/build_claim - json was #{JSON.pretty_generate(JSON.parse(json))}"

    response = HTTParty.post("#{api_base}/claims/build_claim", body: json, headers: { 'Accept': 'application/json', 'Content-Type': 'application/json' })
    raise_on_response(response)
  rescue ::Net::OpenTimeout
    raise Timeout.new('Timeout')
  end

  def create_reference(postcode:, api_base: ENV.fetch('ET_API_URL'), uuid: SecureRandom.uuid)
    json = ApplicationController.render 'api/reference/create_reference.json.jbuilder', locals: {
      post_code: postcode, uuid: uuid
    }
    Rails.logger.info "Sent reference request to API at #{api_base}/references/create_reference - json was #{JSON.pretty_generate(JSON.parse(json))}"

    response = HTTParty.post("#{api_base}/references/create_reference", body: json, headers: { 'Accept': 'application/json', 'Content-Type': 'application/json' })
    raise_on_response(response)
    JSON.parse(response.body)['data'].deep_symbolize_keys
  rescue ::Net::OpenTimeout
    raise Timeout.new('Timeout')
  end

  def raise_on_response(response)
    case response.code
    when 422 then raise UnprocessableEntity.new('Unprocessible entity', response.body)
    when 400 then raise BadRequest.new('Bad request', response.body)
    when 500 then raise InternalServerError.new('Internal server error', response.body)

    end
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
end
