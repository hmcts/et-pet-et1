# Namespace for encapsulating Payment gateway related code
# rubocop:disable Style/StructInheritance
module PaymentGateway
  # Encapsulates ePDQ request related code
  class Request < Struct.new(:request, :options)
    delegate :request_url, :form_attributes, to: :epdq_request

    private

    def epdq_request
      @request ||= EPDQ::Request.new(
        currency: 'GBP', language: 'en_US',
        accepturl: return_url(:success), declineurl: return_url(:decline),
        amount: options[:amount], orderid: options[:reference], tp: template_url
      )
    end

    def uri
      @uri ||= URI.parse request.url
    end

    def template_url
      url_helper :barclaycard_payment_template_url
    end

    def return_url(mode)
      url_helper "#{mode}_claim_payment_url"
    end

    def url_helper(path)
      Rails.application.routes.url_helpers.send path,
        host: uri.host, port: uri.port, protocol: uri.scheme
    end
  end
end
# rubocop:enable Style/StructInheritance
