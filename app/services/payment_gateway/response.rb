module PaymentGateway
  class Response
    SUCCESS_CODES = ['5', '51', '9', '91'].freeze

    attr_reader :request

    def initialize(request)
      @request = request
    end

    def valid?
      EPDQ::Response.new(request.query_string).valid_signature?
    rescue RuntimeError
      # EPDQ::Response#valid_signature? raises error when SHASIGN is missing
      # This error is likely if someone starts poking at the system so catch it.
      false
    end

    def success?
      SUCCESS_CODES.include? status
    end

    def amount
      params['AMOUNT']
    end

    def reference
      params['PAYID']
    end

    def status
      params['STATUS']
    end

    private def params
      @params ||= Hash[CGI.parse(request.query_string).map { |k, v| [k.upcase, v.first] }]
    end
  end
end
