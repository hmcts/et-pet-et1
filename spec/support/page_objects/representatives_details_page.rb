require_relative './base_page'
module ET1
  module Test
    class RepresentativesDetailsPage < BasePage
      set_url "/en/apply/representative"

      # Fills in the representative's details by answering Yes to the question then filling in the details
      # @param [Representative] representative The representative
      def fill_in_representative(representative)
        do_you_have_representative_question.set(:'representatives_details.do_you_have_representative.options.yes')
        fill_in_about_your_representative(representative)
        fill_in_representatives_contact_details(representative)
      end

      def fill_in_about_your_representative(representative)
        about_your_representative_group.tap do |s|
          s.type_question.set(representative.type)
          s.name_of_organisation_question.set(representative.name_of_organisation)
          s.name_question.set(representative.name)
        end
      end

      def fill_in_representatives_contact_details(representative)
        representatives_contact_details_group.tap do |s|
          s.building_question.set(representative.address_building)
          s.street_question.set(representative.address_street)
          s.town_question.set(representative.address_town)
          s.county_question.set(representative.address_county)
          s.post_code_question.set(representative.address_post_code)
          s.phone_or_mobile_number_question.set(representative.phone_or_mobile_number)
          s.alternative_phone_or_mobile_number_question.set(representative.alternative_phone_or_mobile_number)
          s.email_address_question.set(representative.email_address)
          s.dx_number_question.set(representative.dx_number)
          s.best_correspondence_method_question.set(representative.best_correspondence_method)
        end
      end

      # Cancel the representative by clicking No in the primary question
      def no_representative
        do_you_have_representative_question.set(:'representatives_details.do_you_have_representative.options.no')
      end

      # Clicks the save and continue button
      def save_and_continue
        save_and_continue_element.click
      end

      # @param [Hash] error_messages A list of error messages keyed by the question name (ignoring groups)
      def assert_error_messages(error_messages)
        aggregate_failures 'validating error messages' do
          error_messages.each_pair do |question_prefix, expected_message|
            question = :"#{question_prefix}_question"
            [:about_your_representative_group, :representatives_contact_details_group].any? do |group|
              next unless send(group).respond_to?(question)
              send(group).send(question).assert_error_message(t(expected_message))
            end
          end

        end
      end


      private

      section :do_you_have_representative_question, ::ET1::Test::RadioButtonsQuestionSection, :question_group_labelled_translated, 'representatives_details.do_you_have_representative.label'
      section :about_your_representative_group, :fieldset_translated, 'representatives_details.about_your_representative_group' do
        section :type_question, ::ET1::Test::SelectQuestionSection, :question_labelled_translated, 'representatives_details.type.label'
        section :name_of_organisation_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'representatives_details.name_of_organisation.label'
        section :name_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'representatives_details.name.label'
      end

      section :representatives_contact_details_group, :fieldset_translated, 'representatives_details.representatives_contact_details_group' do
        section :building_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'representatives_details.building.label'
        section :street_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'representatives_details.street.label'
        section :town_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'representatives_details.town.label'
        section :county_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'representatives_details.county.label'
        section :post_code_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'representatives_details.post_code.label'
        section :phone_or_mobile_number_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'representatives_details.phone_or_mobile_number.label'
        section :alternative_phone_or_mobile_number_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'representatives_details.alternative_phone_or_mobile_number.label'
        section :email_address_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'representatives_details.email_address.label'
        section :dx_number_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'representatives_details.dx_number.label'
        section :best_correspondence_method_question, ::ET1::Test::RadioButtonsQuestionSection, :question_group_labelled_translated, 'representatives_details.best_correspondence_method.label'
      end

      element :save_and_continue_element, :button_translated, "representatives_details.save_and_continue"
    end
  end
end
