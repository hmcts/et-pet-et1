module HealthcheckComponent
  class BarclaycardGateway < Component
    delegate :available?, to: :PaymentGateway
  end
end
