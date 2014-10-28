class ClaimGenerator
  def initialize(claim)
    @claim = claim
  end

  def to_xml
    Jadu::ClaimSerializer.new(@claim).to_xml
  end
end
