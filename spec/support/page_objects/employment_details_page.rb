require_relative './base_page'
module ET1
  module Test
    class EmploymentDetailsPage < BasePage
      set_url "/en/apply/employment"


      # @param [ET1::Test::EmploymentUi] employment user employment inputs
      def fill_in_all(employment:)
        was_employed_question.set(employment.was_employed)
        current_situation_question.set(employment.current_situation)
        job_title_question.set(employment.job_title)
        start_date_question.set(employment.start_date)
        notice_period_end_date_question.set(employment.notice_period_end_date) if employment.current_situation.to_s.split('.').last == 'notice_period'
        end_date_question.set(employment.end_date) if employment.current_situation.to_s.split('.').last == 'employment_terminated'
        worked_notice_period_question.set(employment.worked_notice_period)
        if employment.worked_notice_period.to_s.split('.').last == 'true'
          notice_pay_period_count_question.set(employment.notice_pay_period_count)
          notice_pay_period_type_question.set(employment.notice_pay_period_type)
        end
        hours_worked_per_week_question.set(employment.hours_worked_per_week)
        pay_period_type_question.set(employment.pay_period_type)
        gross_pay_question.set(employment.gross_pay)
        net_pay_question.set(employment.net_pay)
        in_pension_scheme_question.set(employment.in_pension_scheme)
        benefits_question.set(employment.benefits)
        found_new_job_question.set(employment.found_new_job)
        if employment.found_new_job.to_s.split('.').last == 'true'
          new_job_start_date_question.set(employment.new_job_start_date)
          new_job_gross_pay_question.set(employment.new_job_gross_pay)
          new_job_pay_period_type_question.set(employment.new_job_pay_period_type)
        end
      end
      # Clicks the save and continue button
      def save_and_continue
        save_and_continue_button.submit
      end

      private

      # @!method was_employed_question
      #   A govuk radio button component for 'Have you ever been employed by the person ...' question
      #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      gds_radios :was_employed_question, :'employment.was_employed'

      # @!method current_situation_question
      #   A govuk radio button component for 'What is your current work situation' question
      #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      gds_radios :current_situation_question, :'employment.current_situation'

      # @!method job_title_question
      #   A govuk text field component wrapping the input, label, hint etc.. for the Job title
      #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
      gds_text_input :job_title_question, :'employment.job_title'

      # @!method start_date_question
      #   A govuk date field component wrapping the input, label, hint etc.. for the start date question
      #   @return [EtTestHelpers::Components::GovUKDateField] The site prism section
      gds_date_input :start_date_question, :'employment.start_date'

      # @!method end_date_question
      #   A govuk date field component wrapping the input, label, hint etc.. for the end date question
      #   @return [EtTestHelpers::Components::GovUKDateField] The site prism section
      gds_date_input :end_date_question, :'employment.end_date'

      # @!method notice_period_end_date_question
      #   A govuk date field component wrapping the input, label, hint etc.. for the notice period end date question
      #   @return [EtTestHelpers::Components::GovUKDateField] The site prism section
      gds_date_input :notice_period_end_date_question, :'employment.notice_period_end_date'

      # @!method worked_notice_period_question
      #   A govuk radio button component for 'Did you work (or get paid for) a period of notice' question
      #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      gds_radios :worked_notice_period_question, :'employment.worked_notice_period'

      # @!method notice_pay_period_count_question
      #   A govuk text field component wrapping the input, label, hint etc.. for the 'For how many weeks or months did you get paid?'
      #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
      gds_text_input :notice_pay_period_count_question, :'employment.notice_pay_period_count'

      # @!method notice_pay_period_type_question
      #   A govuk radio button component for 'For how many weeks or months did you get paid?' question
      #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      section :notice_pay_period_type_question, govuk_component(:collection_radio_buttons), :xpath, XPath.generate { |x| x.descendant(:div)[x.attr(:class).contains_word('govuk-form-group') & x.child(:fieldset)[x.attr(:class).contains_word('govuk-fieldset') & x.child(:div)[x.attr(:'data-module').equals('govuk-radios') & x.descendant(:input)[x.attr(:name).equals('employment[notice_pay_period_type]')]]]] }

      # @!method hours_worked_per_week_question
      #   A govuk text field component wrapping the input, label, hint etc.. for the hours worked per week
      #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
      gds_text_input :hours_worked_per_week_question, :'employment.average_hours_worked_per_week'

      # @!method pay_period_type_question
      #   A govuk radio button component for pay_period_type question
      #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      gds_radios :pay_period_type_question, :'employment.pay_period_type'

      # @!method gross_pay_question
      #   A govuk text field component wrapping the input, label, hint etc.. for the 'Pay before tax' question
      #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
      gds_text_input :gross_pay_question, :'employment.gross_pay'

      # @!method net_pay_question
      #   A govuk text field component wrapping the input, label, hint etc.. for the 'Pay before tax' question
      #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
      gds_text_input :net_pay_question, :'employment.net_pay'

      # @!method in_pension_scheme_question
      #   A govuk radio button component for 'Are you a member of your employers pension ...' question
      #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      gds_radios :in_pension_scheme_question, :'employment.enrolled_in_pension_scheme'

      # @!method benefits_question
      #   A govuk text field component wrapping the input, label, hint etc.. for the 'Did you have any benefits ...' question
      #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
      gds_text_area :benefits_question, :'employment.benefit_details'

      # @!method found_new_job_question
      #   A govuk radio button component for 'Have you got a new job?' question
      #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      gds_radios :found_new_job_question, :'employment.found_new_job'

      # @!method new_job_start_date_question
      #   A govuk date field component wrapping the input, label, hint etc.. for the new job start date question
      #   @return [EtTestHelpers::Components::GovUKDateField] The site prism section
      gds_date_input :new_job_start_date_question, :'employment.new_job_start_date'


      # @!method new_job_gross_pay_question
      #   A govuk text field component wrapping the input, label, hint etc.. for the 'Pay before tax' question
      #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
      gds_text_input :new_job_gross_pay_question, :'employment.new_job_gross_pay'

      # @!method new_job_gross_pay_period_type_question
      #   A govuk radio button component for 'Did you work (or get paid for) a period of notice' question
      #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      gds_radios :new_job_pay_period_type_question, :'employment.new_job_pay_period_type'

      # @!method save_and_continue_button
      #   A govuk submit button component...
      #   @return [EtTestHelpers::Components::GovUKSubmit] The site prism section
      gds_submit_button :save_and_continue_button, :'employment.save_and_continue.label'
    end
  end
end
