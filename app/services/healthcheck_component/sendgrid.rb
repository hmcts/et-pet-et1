module HealthcheckComponent
  class Sendgrid < Component
    def available?
      smtp_response.success?
    end

    private

    HOST = ActionMailer::Base.smtp_settings.fetch(:address).freeze
    PORT = ActionMailer::Base.smtp_settings.fetch(:port).freeze
    private_constant :HOST, :PORT

    def smtp_response
      Net::SMTP.start(HOST, PORT) do |smtp|
        smtp.helo(Socket.gethostname)
      end
    end
  end
end
