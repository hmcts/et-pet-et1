class FeeGroupReference
  attr_reader :reference

  class << self
    def create(postcode:)
      new(postcode).tap &:perform
    end
  end

  def initialize(postcode)
    @postcode = postcode
  end

  def perform
    if request.success?
      @reference = request['fgr']
    else
      raise RuntimeError.new "Error #{request['errorCode']}: #{request['errorDescription']}"
    end
  end

  private def request
    @request ||= HTTParty.post \
      ENV['FEE_GROUP_REFERENCE_SERVICE_URL'],
      body: { postcode: @postcode },
      headers: { 'Accept' => 'application/json' }
  end
end
