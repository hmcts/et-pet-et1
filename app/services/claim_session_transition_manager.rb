class ClaimSessionTransitionManager
  TRANSITIONS = [
    { from: 'password', to: 'claimant' },
    { from: 'claimant', to: 'representative', if: 'has_representative' },
    { from: 'claimant', to: 'respondent' },
    { from: 'representative', to: 'respondent' },
    { from: 'respondent', to: 'employment', if: 'was_employed' },
    { from: 'respondent', to: 'claim' },
    { from: 'employment', to: 'claim' },
    { from: 'claim',      to: 'confirmation' }
  ].freeze

  def initialize(session:)
    @session = session
  end

  def perform!(resource:)
    if t = transition(resource)
      stack.push t[:to]
    end
  end

  def current_step
    stack.last
  end

  def previous_step
    stack[-2]
  end

  private def stack
    @session['step_stack'] ||= ['password']
  end

  private def transition(resource)
    TRANSITIONS.find do |t|
      next unless t[:from] == current_step

      condition = t[:if]
      condition ? resource.send(condition) : true
    end
  end
end
