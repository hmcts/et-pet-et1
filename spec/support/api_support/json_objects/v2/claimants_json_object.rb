require_relative './base'
module Et1
  module Test
    module JsonObjects
      module V2
        # Represents the JSON attributes for an array of claimants
        class ClaimantsJsonObject < Base

          def has_valid_json_for_models?(example_claimants, errors: [], indent: 1)
            example_claimants.each_with_index do |claimant, idx|
              ClaimantJsonObject.new(json[idx]).has_valid_json_for_model?(claimant)
            end
            errors.empty?
          end
        end
      end
    end
  end
end
