require_relative './base'
module Et1
  module Test
    module JsonObjects
      module V2
        class BuildPdfFileJsonObject < Base
          include RSpec::Matchers
          include RSpec::Mocks::ArgumentMatchers

          def has_valid_json_for_model?(file, errors: [], indent: 1)
            expect(json).to include command: 'BuildPdfFile',
                                    uuid: instance_of(String)
            expect(json[:data]).to include checksum: nil,
                                           data_from_key: nil,
                                           data_url: file.url,
                                           filename: file.filename
          rescue RSpec::Expectations::ExpectationNotMetError => err
            errors << "Missing or invalid BuildPdfFile command json"
            errors.concat(err.message.lines.map { |l| "#{'  ' * indent}#{l.gsub(/\n\z/, '')}" })
            false
          end
        end
      end
    end
  end
end
