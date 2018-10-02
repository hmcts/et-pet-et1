module Et1
  module Test
    module JsonObjects
      module V2
        class CreateReferenceJsonObject < Base
          include RSpec::Matchers
          include RSpec::Mocks::ArgumentMatchers
          def has_valid_json_for_model?(model, errors: [], indent: 1)
            expect(json).to include command: 'CreateReference',
                                    uuid: instance_of(String),
                                    data: a_hash_including(post_code: model.post_code)
          rescue RSpec::Expectations::ExpectationNotMetError => err
            errors << "Missing or invalid CreateReference command json"
            errors.concat(err.message.lines.map { |l| "#{'  ' * indent}#{l.gsub(/\n\z/, '')}" })
            false
          end
        end
      end
    end
  end
end
