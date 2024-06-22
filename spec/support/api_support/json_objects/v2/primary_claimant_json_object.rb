require_relative './base'
module Et1
  module Test
    module JsonObjects
      module V2
        # Represents the JSON attributes for a claimant
        class PrimaryClaimantJsonObject < Base
          include RSpec::Matchers

          def has_valid_json_for_model?(example_claimant, errors: [], indent: 1)
            example_address = example_claimant.address
            expect(json).to include title: example_claimant.title == 'Other' ? example_claimant.other_title : example_claimant.title,
                                    first_name: example_claimant.first_name,
                                    last_name: example_claimant.last_name,
                                    gender: {'male' => 'Male', 'female' => 'Female', 'prefer_not_to_say' => 'N/K'}[example_claimant.gender],
                                    email_address: example_claimant.email_address,
                                    date_of_birth: example_claimant.date_of_birth.strftime('%Y-%m-%d'),
                                    contact_preference: example_claimant.contact_preference.try(:humanize),
                                    allow_video_attendance: example_claimant.allow_phone_or_video_attendance.include?('video'),
                                    allow_phone_attendance: example_claimant.allow_phone_or_video_attendance.include?('phone'),
                                    no_phone_or_video_reason: example_claimant.allow_phone_or_video_attendance == ['neither'] ? example_claimant.allow_phone_or_video_reason : nil,
                                    fax_number: example_claimant.fax_number,
                                    special_needs: example_claimant.special_needs,
                                    mobile_number: example_claimant.mobile_number,
                                    address_telephone_number: example_claimant.address_telephone_number,
                                    address_attributes: example_address.nil? || example_address.empty? ? {} : a_hash_including(building: example_address.building, county: example_address.county, locality: example_address.locality, post_code: example_address.post_code, street: example_address.street, country: mapped_country(example_address.country))
          rescue RSpec::Expectations::ExpectationNotMetError => err
            errors << "Missing or invalid claimant json"
            errors.concat(err.message.lines.map { |l| "#{'  ' * indent}#{l.gsub(/\n\z/, '')}" })
            false
          end

          def mapped_country(country)
            return nil if country.nil?
            {"united_kingdom" => "United Kingdom", "other" => "Outside United Kingdom"}[country]
          end
        end
      end
    end
  end
end
