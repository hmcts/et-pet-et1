class ClaimGenerator
  attr_reader :errors

  def initialize(claim)
    @claim = claim
    @errors = []
  end

  def to_xml
    Jadu::ClaimSerializer.new(@claim).to_xml
  end

  def valid?
    xsd = Nokogiri::XML::Schema(File.read(Rails.root.join('lib/assets/ETFees.xsd')))
    doc = Nokogiri::XML(to_xml)
    @errors = xsd.validate(doc)
    @errors == []
  end
end
