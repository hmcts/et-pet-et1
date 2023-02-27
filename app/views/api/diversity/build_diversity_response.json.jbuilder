json.uuid uuid
json.command 'BuildDiversityResponse'
json.data do
  json.call(response, :claim_type, :sex, :sexual_identity, :age_group, :ethnicity, :ethnicity_subgroup, :disability,
            :caring_responsibility, :gender, :gender_at_birth, :pregnancy, :relationship, :religion)
end
