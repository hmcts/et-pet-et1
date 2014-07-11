class TransitionManager
  Transition = Struct.new(:from, :to, :condition)

  class << self
    def rules
      @rules ||= []
    end

    def transition(rule)
      self.rules << Transition.new(*rule.shift, rule[:if])
    end
  end

  def initialize(resource:)
    @resource = resource
  end

  def forward
    if transition = candidates.find { |c| c.condition ? @resource.send(c.condition) : true }
      transition.to
    end
  end

  private def candidates
    model_name = @resource.class.model_name_i18n_key
    self.class.rules.select { |t| t.from == model_name }
  end
end
