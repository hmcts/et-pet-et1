module HealthcheckComponent
  class RabbitMq < Component
    def available?
      session.start
      session.connected?
    ensure
      session.close
    end

    private

    def session
      @session ||= Bunny.new(
        Sneakers::CONFIG[:amqp],
        heartbeat: Sneakers::CONFIG[:heartbeat],
        vhost: Sneakers::CONFIG[:vhost])
    end
  end
end
