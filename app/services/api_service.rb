class ApiService
  include ActiveModel::Model

  attr_reader :response_data

  def valid?
    errors.empty?
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

  def send_request(json, path:, subject:, api_base: ENV.fetch('ET_API_URL'))
    log_json(json, url: "#{api_base}#{path}", subject:)

    request = typhoeus_request_object
    perform_requests(request)
    self.response = request.response
    parse_response
    log_response
    raise_on_response_code
    raise_on_return_code
    generate_errors
    response
  end

  def typhoeus_request_object
    Typhoeus::Request.new "#{api_base}#{path}",
                          verbose: true, method: :post, body: json,
                          headers: { 'Accept': 'application/json', 'Content-Type': 'application/json' }
  end

  def parse_response
    self.response_data = JSON.parse(response.body)
  rescue JSON::ParserError
    self.response_data = {}
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

  def log_response
    Rails.logger.info "API Responded with status #{response.code}," \
                        " a return code of #{response.return_code}," \
                        " and a body of #{response.body}"
  end

  def raise_on_response_code
    case response.code
    when 200, 201, 202, 0, 422 then nil
    when 400 then raise BadRequest.new('Bad request', response.body)
    when 500 then raise InternalServerError.new('Internal server error', response.body)
    else raise UnknownResponse.new("An unknown response code of #{response.code} was returned from the api",
                                   response.body)
    end
  end

  def raise_on_return_code
    case response.return_code
    when nil, :ok, 0 then nil
    when :operation_timedout then raise Timeout, 'Timeout'
    else raise UnknownResponse.new("Unknown response return code - #{response.return_code}", response.body)
    end
  end

  def generate_errors
    return unless response.code == 422

    if response_data['status'] == 'not_accepted'
      generate_custom_errors
    else
      errors.add :base, :unknown_422_error_from_api
    end
  end

  def generate_custom_errors
    raise "Must be overridden in subclass"
  end

  attr_writer :response_data
  attr_accessor :response

end
