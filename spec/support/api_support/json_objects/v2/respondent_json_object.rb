module Et1
  module Test
    module JsonObjects
      module V2
        # Represents the JSON attributes for a respondent
        class RespondentJsonObject < Base
          include RSpec::Matchers

          def has_valid_json_for_model?(example_respondent, errors: [], indent: 1)
            example_address = example_respondent.address
            example_work_address = example_respondent.work_address
            expect(json).to include acas_certificate_number: example_respondent.acas_early_conciliation_certificate_number,
                                    acas_exemption_code: example_respondent.no_acas_number_reason,
                                    address_attributes: a_hash_including(building: example_address.building, county: example_address.county, locality: example_address.locality, post_code: example_address.post_code, street: example_address.street),
                                    address_telephone_number: example_respondent.address_telephone_number,
                                    alt_phone_number: example_respondent.work_address_telephone_number,
                                    contact: nil,
                                    contact_preference: nil,
                                    disability: nil,
                                    disability_information: nil,
                                    dx_number: nil,
                                    email_address: nil,
                                    employment_at_site_number: nil,
                                    fax_number: nil,
                                    name: example_respondent.name,
                                    organisation_employ_gb: nil,
                                    organisation_more_than_one_site: nil,
                                    work_address_attributes: example_work_address.nil? ? nil : a_hash_including(building: example_work_address.building, county: example_work_address.county, locality: example_work_address.locality, post_code: example_work_address.post_code, street: example_work_address.street),
                                    work_address_telephone_number: example_respondent.work_address_telephone_number

          rescue RSpec::Expectations::ExpectationNotMetError => err
            errors << "Missing or invalid respondent json"
            errors.concat(err.message.lines.map { |l| "#{'  ' * indent}#{l.gsub(/\n\z/, '')}" })
            false
          end
        end
      end
    end
  end
end
