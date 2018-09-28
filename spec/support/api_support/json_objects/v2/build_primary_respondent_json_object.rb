module Et1
  module Test
    module JsonObjects
      module V2
        class BuildPrimaryRespondentJsonObject < Base
          include RSpec::Matchers
          include RSpec::Mocks::ArgumentMatchers
          def has_valid_json_for_model?(model, errors: [], indent: 1)
            expect(json).to include command: 'BuildPrimaryRespondent',
                                    uuid: instance_of(String)
            expect(RespondentJsonObject.new(json[:data])).to have_valid_json_for_model(model, errors: errors, indent: indent + 1)
          rescue RSpec::Expectations::ExpectationNotMetError => err
            errors << "Missing or invalid BuildPrimaryRespondent command json"
            errors.concat(err.message.lines.map { |l| "#{'  ' * indent}#{l.gsub(/\n\z/, '')}" })
            false
          end
        end
      end
    end
  end
end
