module HealthcheckComponent
  class Component
    def self.available?
      new.available? rescue false
    end
  end
end
