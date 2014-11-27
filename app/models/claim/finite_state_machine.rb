class Claim::FiniteStateMachine
  extend StateMachine::MacroMethods

  class << self
    def instance_methods(include_superclass=true)
      super - Object.instance_methods
    end
  end

  def initialize(claim:)
    @claim = claim
    super()
  end

  delegate :state, :state=, to: :@claim

  state_machine :state, initial: :created do
    event :submit do
      transition :created => :enqueued_for_submission,
        if: ->(claim) { claim.submittable? && !claim.payment_applicable? }
      transition :created => :payment_required,
        if: ->(claim) { claim.submittable? && claim.payment_applicable? }
    end

    event :enqueue do
      transition :payment_required => :enqueued_for_submission
    end

    event :finalize do
      transition :enqueued_for_submission => :submitted
    end

    after_transition created: :enqueued_for_submission,
      do: ->(claim) { claim.submitted_at = Time.now }

    after_transition do: ->(claim) { claim.save! }
  end

  private :state, :state=

  def immutable?
    submitted? || enqueued_for_submission?
  end

  private def method_missing(meth, *args, &blk)
    if @claim.respond_to? meth
      @claim.send meth, *args, &blk
    else
      super
    end
  end
end
