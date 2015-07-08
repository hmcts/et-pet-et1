module HealthcheckComponent
  class Sendgrid < Component
    def available?
      helo_response.success?
    end

    private

    def helo_response
      Net::SMTP.start(host, port) do |smtp|
        smtp.helo(Socket.gethostname)
      end
    end

    def host
      ActionMailer::Base.smtp_settings.fetch(:address)
    end

    def port
      ActionMailer::Base.smtp_settings.fetch(:port)
    end
  end
end
