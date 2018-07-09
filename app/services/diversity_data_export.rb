class DiversityDataExport
  require "httpx"
  attr_reader :response

  def initialize(id, uuid)
    @diveristy = Diversity.find(id)
    @uuid = uuid
  end

  def data
    {
      command: 'BuildDiversityResponse',
      data: {
        claim_type: @diveristy.claim_type,
        sex: @diveristy.sex,
        sexual_identity: @diveristy.sexual_identity,
        age_group: @diveristy.age_group,
        ethnicity: @diveristy.ethnicity,
        ethnicity_subgroup: @diveristy.ethnicity_subgroup,
        disability: @diveristy.disability,
        caring_responsibility: @diveristy.caring_responsibility,
        gender: @diveristy.gender,
        gender_at_birth: @diveristy.gender_at_birth,
        pregnancy: @diveristy.pregnancy,
        relationship: @diveristy.relationship,
        religion: @diveristy.religion
      },
      uuid: @uuid
    }
  end

  def headers
    { 'Accept' => 'application/json' }
  end

  def send_data
    uri = URI.join(ENV['ET_API_URL'], '/diversity/build_diversity_response')
    @response = HTTPX.timeout(total_timeout: 10).post(uri, headers: headers, json: data)
  end
end
