module Healthcheck
  COMPONENTS = [
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

  class << self

    private

    def components
      COMPONENTS.map do |component|
        {
          name: component.name.demodulize.underscore.to_s,
          available: component.available?
        }
      end
    end
  end
end
