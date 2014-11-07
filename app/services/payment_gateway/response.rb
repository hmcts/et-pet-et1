# Namespace for encapsulating Payment gateway related code
module PaymentGateway
  # Encapsulates ePDQ response related code
  class Response < Struct.new(:request)
    def valid?
      EPDQ::Response.new(request.query_string).valid_signature?
    rescue RuntimeError
      # EPDQ::Response#valid_signature? raises error when SHASIGN is missing
      # This error is likely if someone starts poking at the system so catch it.
      false
    end

    def success?
      %w<5 51 9 91>.include? params['STATUS']
    end

    def amount
      params['AMOUNT']
    end

    def reference
      params['PAYID']
    end

    private def params
      @params ||= Hash[CGI.parse(request.query_string).map { |k,v| [k.upcase, v.first] }]
    end
  end
end
