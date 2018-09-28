module Et1
  module Test
    module JsonObjects
      module V2
        class BuildSecondaryRespondentsJsonObject < Base
          include RSpec::Matchers
          include RSpec::Mocks::ArgumentMatchers
          def has_valid_json_for_model?(collection, errors, indent: 1)
            expect(json).to include command: 'BuildSecondaryRespondents',
                                    uuid: instance_of(String)
            data_matchers = collection.map do |model|
              be_a_valid_api_command('Respondent').version(2).for_db_data(model)
            end
            expect(json[:data]).to match_array data_matchers
          rescue RSpec::Expectations::ExpectationNotMetError => err
            errors << "Missing or invalid BuildSecondaryRespondents command json"
            errors.concat(err.message.lines.map { |l| "#{'  ' * indent}#{l.gsub(/\n\z/, '')}" })
            false
          end
        end
      end
    end
  end
end
