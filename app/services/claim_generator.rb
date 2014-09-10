class ClaimGenerator
  def initialize(claim)
    @claim = claim
  end

  def to_xml
    @claim.to_xml include: {claimants: {include: :address}, respondents: {include: :address}, representative: {include: :address}}
  end
end
