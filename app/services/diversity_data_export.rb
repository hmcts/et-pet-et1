class DiversityDataExport
  include HTTParty
  base_uri 'http://host:port/api/v2'

  def initialize(id)
    @diveristy = Diversity.find(id)
    @uuid = SecureRandom.uuid
  end

  def format_the_data
    { body: {
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
    }}
  end

  def send_data
    HTTParty.post('/diversity/build_diversity_response', format_the_data)
  end
end
