# Namespace for encapsulating Payment gateway related code
module PaymentGateway
  # Encapsulates ePDQ request related code
  class Request < Struct.new(:request, :options)
    delegate :request_url, :form_attributes, to: :epdq_request

    private

    def epdq_request
      @request ||= EPDQ::Request.new currency: 'GBP', language: 'en_US',
        accepturl: url_helper(:success), declineurl: url_helper(:decline),
        amount: options[:amount], orderid: options[:reference]
    end

    def uri
      @uri ||= URI.parse request.url
    end

    def url_helper(mode)
      Rails.application.routes.url_helpers.send "#{mode}_claim_payment_url",
        host: uri.host, port: uri.port, protocol: uri.scheme
    end
  end
end
