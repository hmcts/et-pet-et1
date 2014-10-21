class ClaimOutcomeForm < Form
  attributes :desired_outcomes, :other_outcome

  validates :other_outcome, length: { maximum: 2500 }

  def desired_outcomes
    attributes[:desired_outcomes].map(&:to_s)
  end

  private def target
    resource
  end
end
