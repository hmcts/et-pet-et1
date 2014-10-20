class TransitionManager
  Transition = Struct.new(:page, :from, :to, :condition)
  LAST_PAGE = 1
  
  class << self
    def rules
      @rules ||= []
    end

    def transition(rule)
      self.rules << Transition.new(self.rules.size + 1, *rule.shift, rule[:if])
    end
  end

  def initialize(resource:)
    @resource = resource
  end

  def forward
    transition.to if transition
  end

  def current_page
    transition.page
  end

  def total_pages
    self.class.rules.size + LAST_PAGE
  end

  private

  def transition
    @transition ||= candidates.find { |c| c.condition ? @resource.send(c.condition) : true }
  end

  def candidates
    model_name = @resource.class.model_name_i18n_key
    self.class.rules.select { |t| t.from == model_name }
  end
end
