module Et1
  module Test
    module JsonObjects
      module V2
        class BuildPrimaryClaimantJsonObject < Base
          include RSpec::Matchers
          include RSpec::Mocks::ArgumentMatchers
          def has_valid_json_for_model?(model, errors: [], indent: 1)
            expect(json).to include command: 'BuildPrimaryClaimant',
                                    uuid: instance_of(String)
            expect(ClaimantJsonObject.new(json[:data])).to have_valid_json_for_model(model, errors: errors, indent: indent + 1)
          rescue RSpec::Expectations::ExpectationNotMetError => err
            errors << "Missing or invalid BuildPrimaryClaimant command json"
            errors.concat(err.message.lines.map { |l| "#{'  ' * indent}#{l.gsub(/\n\z/, '')}" })
            false
          end
        end
      end
    end
  end
end
