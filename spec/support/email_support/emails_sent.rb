module Et1
  module Test
    class EmailsSent
      def initialize(deliveries: ActionMailer::Base.deliveries)
        self.deliveries = deliveries
      end

      def empty?
        deliveries.empty?
      end

      def feedback_html_email_for(email_address:)
        email = Et1::Test::EmailObjects::FeedbackEmailHtml.find(email_address: email_address)
        raise "No HTML feedback email has been sent for email address #{email_address}" unless email.present?
        email
      end

      def feedback_text_email_for(email_address:)
        email = Et1::Test::EmailObjects::FeedbackEmailText.find(email_address: email_address)
        raise "No text feedback email has been sent for email address #{email_address}" unless email.present?
        email
      end

      private

      attr_accessor :deliveries
    end
  end
end
