require_relative './base_page'
module ET1
  module Test
    class ClaimantsDetailsPage < BasePage
      set_url "/en/apply/claimant"


      def fill_in_all(claimant:)
        fill_in_personal_info(claimant: claimant)
        fill_in_special_needs(claimant: claimant)
        fill_in_contact_details(claimant: claimant)
      end
      # Fills in the claimant's personal info
      # @param [Claimant] claimant The claimant
      def fill_in_personal_info(claimant:)
        about_the_claimant_group.tap do |s|
          s.title_question.set(claimant.title)
          s.first_name_question.set(claimant.first_name)
          s.last_name_question.set(claimant.last_name)
          s.date_of_birth_question.set(claimant.date_of_birth)
          s.gender_question.set(claimant.gender)
        end
      end

      # Fills in the special needs section
      # @param [Boolean] has_special_needs A boolean to indicate if the claimant has special needs or not
      # @param [String, NilClass] special_needs A string containing the special needs to fill in (nil if not needed)
      def fill_in_special_needs(claimant:)
        about_the_claimant_group.tap do |s|
          s.has_special_needs_question.set(claimant.has_special_needs)
          s.special_needs_question.set(claimant.special_needs) if claimant.has_special_needs
        end
      end

      # Fills in the contact details section
      # @param [Claimant] claimant The claimant
      def fill_in_contact_details(claimant:)
        claimants_contact_details_group.tap do |s|
          s.building_question.set(claimant.address_building)
          s.street_question.set(claimant.address_street)
          s.town_question.set(claimant.address_town)
          s.county_question.set(claimant.address_county)
          s.post_code_question.set(claimant.address_post_code)
          s.country_question.set(claimant.address_country)
          s.phone_or_mobile_number_question.set(claimant.phone_or_mobile_number)
          s.alternative_phone_or_mobile_number_question.set(claimant.alternative_phone_or_mobile_number)
          s.email_address_question.set(claimant.email_address)
          s.best_correspondence_method_question.set(claimant.best_correspondence_method)
        end
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
            [:about_the_claimant_group, :claimants_contact_details_group].any? do |group|
              next unless send(group).respond_to?(question)
              send(group).send(question).assert_error_message(t(expected_message))
            end
          end

        end
      end

      private

      section :about_the_claimant_group, :fieldset_translated, 'claimants_details.about_the_claimant_group' do

        section :title_question, ::ET1::Test::SelectQuestionSection, :question_labelled_translated, 'claimants_details.title.label'
        section :first_name_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'claimants_details.first_name.label'
        section :last_name_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'claimants_details.last_name.label'
        section :date_of_birth_question, ::ET1::Test::DateQuestionSection, :question_group_labelled_translated, 'claimants_details.date_of_birth.label'
        section :gender_question, ::ET1::Test::RadioButtonsQuestionSection, :question_labelled_translated, 'claimants_details.gender.label'
        section :has_special_needs_question, ::ET1::Test::RadioButtonsQuestionSection, :question_group_labelled_translated, 'claimants_details.has_special_needs.label'
        section :special_needs_question, ::ET1::Test::TextAreaQuestionSection, :question_labelled_translated, 'claimants_details.special_needs.label'
      end

      section :claimants_contact_details_group, :fieldset_translated, 'claimants_details.claimants_contact_details_group' do
        section :building_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'claimants_details.building.label'
        section :street_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'claimants_details.street.label'
        section :town_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'claimants_details.town.label'
        section :county_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'claimants_details.county.label'
        section :post_code_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'claimants_details.post_code.label'
        section :country_question, ::ET1::Test::SelectQuestionSection, :question_labelled_translated, 'claimants_details.country.label'
        section :phone_or_mobile_number_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'claimants_details.phone_or_mobile_number.label'
        section :alternative_phone_or_mobile_number_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'claimants_details.alternative_phone_or_mobile_number.label'
        section :email_address_question, ::ET1::Test::TextQuestionSection, :question_labelled_translated, 'claimants_details.email_address.label'
        section :best_correspondence_method_question, ::ET1::Test::RadioButtonsQuestionSection, :question_group_labelled_translated, 'claimants_details.best_correspondence_method.label'
      end

      element :save_and_continue_element, :button_translated, 'claimants_details.save_and_continue'

    end
  end
end
