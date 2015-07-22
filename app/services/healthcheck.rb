module Healthcheck
  COMPONENTS = [
    HealthcheckComponent::RabbitMq,
    HealthcheckComponent::BarclaycardGateway,
    HealthcheckComponent::Sendgrid
  ].freeze

  def self.report
    HealthcheckReport.new components
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
