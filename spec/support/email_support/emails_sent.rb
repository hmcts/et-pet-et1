module Et1
  module Test
    class EmailsSent
      def initialize(deliveries: ActionMailer::Base.deliveries)
        self.deliveries = deliveries
      end

      def empty?
        deliveries.empty?
      end

      private

      attr_accessor :deliveries
    end
  end
end
