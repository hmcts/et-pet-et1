class ClaimGenerator
  attr_reader :errors

  def initialize(claim)
    @claim = claim
    @errors = []
  end

  def to_xml(options={})
    Jadu::ClaimSerializer.new(@claim).to_xml(options)
  end

  def valid?(options={})
    xsd = Nokogiri::XML::Schema(File.read(Rails.root.join('lib/assets/ETFees.xsd')))
    doc = Nokogiri::XML(to_xml(options))
    @errors = xsd.validate(doc)
    @errors == []
  end
end
