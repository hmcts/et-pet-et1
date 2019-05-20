require_relative './base'
module Et1
  module Test
    module JsonObjects
      module V2
        class BuildDiversityResponseJsonObject < Base
          include RSpec::Matchers
          include RSpec::Mocks::ArgumentMatchers
          def has_valid_json_for_model?(model, errors: [], indent: 1)
            expect(json).to include command: 'BuildDiversityResponse',
                                    uuid: instance_of(String),
                                    data: a_hash_including(claim_type: model.claim_type,
                                                           sex: model.sex,
                                                           sexual_identity: model.sexual_identity,
                                                           age_group: model.age_group,
                                                           ethnicity: model.ethnicity,
                                                           ethnicity_subgroup: model.ethnicity_subgroup,
                                                           disability: model.disability,
                                                           caring_responsibility: model.caring_responsibility,
                                                           gender: model.gender,
                                                           gender_at_birth: model.gender_at_birth,
                                                           pregnancy: model.pregnancy,
                                                           relationship: model.relationship,
                                                           religion: model.religion)
          rescue RSpec::Expectations::ExpectationNotMetError => err
            errors << "Missing or invalid BuildDiversityResponse command json"
            errors.concat(err.message.lines.map { |l| "#{'  ' * indent}#{l.gsub(/\n\z/, '')}" })
            false
          end
        end
      end
    end
  end
end
