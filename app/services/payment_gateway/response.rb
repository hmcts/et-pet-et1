# TODO: take a look at this rubocop warning
# rubocop:disable Style/StructInheritance
module PaymentGateway
  class Response < Struct.new(:request)
    SUCCESS_CODES = ['5', '51', '9', '91'].freeze

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
# rubocop:enable Style/StructInheritance
