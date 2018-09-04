class DiversityDataExport
  require "httpx"
  attr_reader :response
  KEYS = [:claim_type, :sex, :sexual_identity, :age_group, :ethnicity,
          :ethnicity_subgroup, :disability, :caring_responsibility, :gender,
          :gender_at_birth, :pregnancy, :relationship, :religion].freeze

  def initialize(id, uuid)
    @diversity = Diversity.find(id)
    @uuid = uuid
  end

  def send_data
    uri = File.join(ENV['ET_API_URL'], '/diversity/build_diversity_response')
    @response = HTTPX.timeout(total_timeout: 10).post(uri, headers: headers, json: data)
  end

  private

  def data
    {
      command: 'BuildDiversityResponse',
      data: diversity_hash,
      uuid: @uuid
    }
  end

  def headers
    { 'Accept' => 'application/json' }
  end

  def diversity_hash
    div_hash = {}
    KEYS.each { |key| div_hash.merge!(key.to_sym => @diversity.send(key)) }
    div_hash
  end

end
