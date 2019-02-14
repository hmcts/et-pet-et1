class Claim::FiniteStateMachine
  extend StateMachine::MacroMethods

  class << self
    def instance_methods(include_superclass = true)
      super - Object.instance_methods
    end
  end

  def initialize(claim:)
    @claim = claim
    super()
  end

  attr_reader :claim

  delegate :state, :state=, to: :@claim

  # rubocop:disable Style/AlignHash
  state_machine :state, initial: :created do
    event :submit do
      transition created: :enqueued_for_submission,
        if: ->(claim) { claim.submittable? }
    end

    event :finalize do
      transition enqueued_for_submission: :submitted
    end

    after_transition do: ->(claim) { claim.save! }

    after_transition any => :enqueued_for_submission, do: lambda { |machine|
      claim = machine.claim

      claim.touch(:submitted_at)
      claim.create_event Event::ENQUEUED
      ClaimSubmissionJob.perform_later claim, SecureRandom.uuid
    }
  end
  # rubocop:enable Style/AlignHash

  private :state, :state=

  def immutable?
    submitted? || enqueued_for_submission?
  end

  private

  # rubocop:disable Style/MethodMissing
  def method_missing(meth, *args, &blk)
    if @claim.respond_to? meth
      @claim.send meth, *args, &blk
    else
      super
    end
  end
  # rubocop:enable Style/MethodMissing

end
