module Healthcheck
  COMPONENTS = [
    HealthcheckComponent::RabbitMq,
    HealthcheckComponent::BarclaycardGateway,
    HealthcheckComponent::Sendgrid
  ].freeze

  def self.report
    Rails.cache.fetch('healthcheck',
        expires_in: 30.seconds,
        race_condition_ttl: 5.seconds) do
      HealthcheckReport.new components
    end
  end

  private

  def self.components
    COMPONENTS.map do |component|
      {
        name: "#{component.name.demodulize.underscore}",
        available: component.available?
      }
    end
  end
end
