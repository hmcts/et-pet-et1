class ClaimForm < Form
  attributes :desired_outcomes, :other_outcome

  validates :other_outcome, length: { maximum: 2500 }


  private def target
    resource
  end
end
