require_relative './base'
module Et1
  module Test
    module JsonObjects
      module V2
        # Represents the JSON attributes for a respondent
        class RepresentativeJsonObject < Base
          include RSpec::Matchers

          def has_valid_json_for_model?(example_rep, errors: [], indent: 1)
            example_address = example_rep.address
            expect(json).to include address_attributes: example_address.nil? || example_address.empty? ? {} : a_hash_including(building: example_address.building, county: example_address.county, locality: example_address.locality, post_code: example_address.post_code, street: example_address.street),
                                    address_telephone_number: example_rep.address_telephone_number,
                                    contact_preference: nil,
                                    dx_number: example_rep.dx_number,
                                    email_address: example_rep.email_address,
                                    fax_number: nil,
                                    mobile_number: example_rep.mobile_number,
                                    name: example_rep.name,
                                    organisation_name: example_rep.organisation_name,
                                    reference: nil,
                                    representative_type: rep_types[example_rep.type]

          rescue RSpec::Expectations::ExpectationNotMetError => err
            errors << "Missing or invalid respondent json"
            errors.concat(err.message.lines.map { |l| "#{'  ' * indent}#{l.gsub(/\n\z/, '')}" })
            false
          end

          private

          def rep_types
            {
              'citizen_advice_bureau' => 'CAB',
              'free_representation_unit' => 'FRU',
              'law_centre' => 'Law Centre',
              'trade_union' => 'Union',
              'solicitor' => 'Solicitor',
              'private_individual' => 'Private Individual',
              'trade_association' => 'Trade Association',
              'other' => 'Other'
            }
          end
        end
      end
    end
  end
end
