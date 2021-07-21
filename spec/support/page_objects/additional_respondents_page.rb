require_relative './base_page'
module ET1
  module Test
    class AdditionalRespondentsPage < BasePage
      set_url "/en/apply/additional-respondents"
      # Adds a list of secondary respondents using the user interface -
      # If the list is not empty it clicks "Yes" to the 'Claims against more than one employer'
      # question, then fills in the sections below it.
      # If the list is empty it clicks "No" to the 'Claims against more than one employer'
      #
      # @param [Array<ET1::Test::SecondaryRespondentUi>] secondary_respondents An array of respondents to add
      def fill_in_all(secondary_respondents:)
        if secondary_respondents.nil? || secondary_respondents.empty?
          no_secondary_respondents
        else
          add_secondary_respondents(secondary_respondents)
        end

        self
      end

      # Remove a secondary respondent already present
      # @param [Integer] index Zero based position of secondary claimant to remove
      def remove_respondent(index:)
        respondent_section(index: index).remove
        self
      end

      def append_secondary_respondents(respondents)
        return if respondents.nil? || respondents.empty?
        starting_index = secondary_respondent_sections.last.index

        respondents.each_with_index do |respondent, index|
          add_respondent_section
          respondent_section(index: index + starting_index + 1).set(respondent)
        end
        self
      end

      def secondary_respondents
        secondary_respondent_sections.map do |s|
          ET1::Test::SecondaryRespondentUi.new.tap do |obj|
            obj.name = s.name.value
            obj.address_building = s.building.value
            obj.address_street = s.street.value
            obj.address_town = s.town.value
            obj.address_county = s.county.value
            obj.address_post_code = s.post_code.value
            key = t('respondents_details.have_acas_number.options').key(s.have_acas_number.value)
            obj.has_acas_number = :"respondents_details.have_acas_number.options.#{key}"
            if(obj.has_acas_number.to_s.split('.').last == 'no')
              obj.dont_have_acas_number_reason = s.dont_have_acas_number_reason.value
            else
              obj.acas_number = s.acas_number.value
            end
          end
        end
      end

      def no_secondary_respondents
        claim_against_other_person_question.set(:'additional_respondents.claim_against_other_person.options.no')
        self
      end

      # Clicks the save and continue button
      def save_and_continue
        save_and_continue_button.submit
        self
      end

      private

      def add_secondary_respondents(respondents)
        return if respondents.nil? || respondents.empty?

        claim_against_other_person_question.set(:'additional_respondents.claim_against_other_person.options.yes')
        respondents.each_with_index do |respondent, index|
          add_respondent_section unless index.zero?
          respondent_section(index: index).set(respondent)
        end
        self
      end

      class RespondentSection < BaseSection
        def set(respondent)
          name.set(respondent.name)
          building.set(respondent.address_building)
          street.set(respondent.address_street)
          town.set(respondent.address_town)
          county.set(respondent.address_county)
          post_code.set(respondent.address_post_code)
          have_acas_number.set(t respondent.has_acas_number)
          if respondent.has_acas_number.to_s.split.last == 'false'
            dont_have_acas_number_reason.set(respondent.dont_have_acas_number_reason)
          else
            acas_number.set(respondent.acas_number)
          end
        end

        def index
          fieldset.respondent_number.text.match(/(\d*)\z/)[0].to_i - 2
        end

        def remove
          remove_this_respondent_element.click
        end

        private

        section :fieldset, :xpath, XPath.generate {| x| x.child(:fieldset) } do
          element :respondent_number, :xpath, XPath.generate { |x| x.child(:legend) }
        end
        gds_text_input :name, :'additional_respondents.name'
        gds_text_input :building, :'additional_respondents.building'
        gds_text_input :street, :'additional_respondents.street'
        gds_text_input :town, :'additional_respondents.town'
        gds_text_input :county, :'additional_respondents.county'
        gds_text_input :post_code, :'additional_respondents.post_code'
        gds_text_input :acas_number, :'additional_respondents.acas_number'
        gds_radios :have_acas_number, :'additional_respondents.have_acas_number'
        gds_radios :dont_have_acas_number_reason, :'additional_respondents.dont_have_acas_number_reason'
        element :remove_this_respondent_element, :link, t('additional_respondents.remove_this_respondent')
      end

      def add_respondent_section
        add_more_respondents_action.submit
      end

      def respondent_section(index:)
        RespondentSection.new(self, find(:xpath, XPath.generate {|x| x.descendant(:div)[x.attr(:class).contains_word('multiple') & x.child(:fieldset)[x.child(:legend)[x.string.n.equals(t('additional_respondents.respondent_section.label', number: index +2))]]]}))
      end

      # @!method govuk_radios
      #   A govuk radio button component wrapping the input, label, hint etc..
      #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      gds_radios :claim_against_other_person_question, :'additional_respondents.claim_against_other_person'

      # @!method add_more_respondents_action
      #   A govuk submit button component...
      #   @return [EtTestHelpers::Components::GovUKErrorSummary] The site prism section
      gds_submit_button :add_more_respondents_action, :'additional_respondents.add_more_respondents.label'

      sections :secondary_respondent_sections, RespondentSection, :xpath, XPath.generate {|x| x.descendant(:div)[x.attr(:class).contains_word('multiple')]}

      # @!method save_and_continue_button
      #   A govuk submit button component for the save and continue button
      #   @return [EtTestHelpers::Components::GovUKSubmit] The site prism section
      gds_submit_button :save_and_continue_button, :'additional_respondents.save_and_continue'
    end
  end
end
