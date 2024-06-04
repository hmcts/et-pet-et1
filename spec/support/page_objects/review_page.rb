require_relative './base_page'
module ET1
  module Test
    class ReviewPage < BasePage
      set_url "/en/apply/review"
      section :group_claim, :govuk_summary_list, :'review.group_claim.title' do
        section :group_claim, :govuk_summary_list_row, :'review.group_claim.questions.group_claim' do
          element :answer, :govuk_summary_list_col
        end
        section :csv_file_name, :govuk_summary_list_row, :'review.group_claim.questions.csv_file_name' do
          element :answer, :govuk_summary_list_col
        end
        section :number_of_additional_claimants, :govuk_summary_list_row, :'review.group_claim.questions.number_of_additional_claimants' do
          element :answer, :govuk_summary_list_col
        end
        sections :claimants, :et1_review_additional_claimant_labelled, 'review.group_claim.claimant_header' do
          include RSpec::Matchers
          include ET1::Test::I18n
          section :full_name, :govuk_summary_list_row, :'review.group_claim.claimant.questions.full_name' do
            element :answer, :govuk_summary_list_col
          end

          section :date_of_birth, :govuk_summary_list_row, :'review.group_claim.claimant.questions.date_of_birth' do
            element :answer, :govuk_summary_list_col
          end

          section :address, :govuk_summary_list_row, :'review.group_claim.claimant.questions.address' do
            element :answer, :govuk_summary_list_col
          end

          def valid_for_model?(model)
            aggregate_failures 'validating claimant' do
              expected_title = model.title.present? ? "#{t("review.group_claim.claimant.person_title.#{model.title}")} " : ''
              expect(full_name.answer).to have_text "#{expected_title}#{model.first_name} #{model.last_name}"
              expect(date_of_birth.answer).to have_text model.date_of_birth.strftime('%d %B %Y')
              a=model.address
              expect(address.answer).to have_text "#{a.building}#{a.street}#{a.locality}#{a.county}#{a.post_code}"
              valid?
            end
            true
          end

          def valid?
            expect(questions.length).to be 3
          end

          private

          elements :questions, :css, '.govuk-summary-list__row'
        end

      end
      section :additional_respondents_section, :govuk_summary_list, :'review.additional_respondents.title' do
        section :additional_respondents, :govuk_summary_list_row, :'review.additional_respondents.questions.additional_respondents' do
          element :answer, :govuk_summary_list_col
        end
        sections :respondents, :et1_review_additional_claimant_labelled, 'review.additional_respondents.respondent_header' do
          include RSpec::Matchers
          include ET1::Test::I18n
          section :name, :govuk_summary_list_row, :'review.additional_respondents.respondent.questions.name' do
            element :answer, :govuk_summary_list_col
          end

          section :acas_number, :govuk_summary_list_row, :'review.additional_respondents.respondent.questions.acas_number' do
            element :answer, :govuk_summary_list_col
          end

          section :address, :govuk_summary_list_row, :'review.additional_respondents.respondent.questions.address' do
            element :answer, :govuk_summary_list_col
          end

          def valid_for_model?(model)
            aggregate_failures 'validating respondent' do
              expect(name.answer).to have_text model.name
              expect(acas_number.answer).to have_text model.acas_early_conciliation_certificate_number
              a=model.address
              expect(address.answer).to have_text "#{a.building}#{a.street}#{a.locality}#{a.county}#{a.post_code}"
              valid?
            end
            true
          end

          def valid?
            expect(questions.length).to be 3
          end

          private

          elements :questions, :css, '.govuk-summary-list__row'
        end
      end
      section :additional_information, :govuk_summary_list, :'review.additional_information.title' do
        section :important_details, :govuk_summary_list_row, :'review.additional_information.questions.important_details' do
          element :answer, :govuk_summary_list_col
        end
      end
      section :claim_details, :govuk_summary_list, :'review.claim_details.title' do
        section :claim_details, :govuk_summary_list_row, :'review.claim_details.questions.claim_details' do
          element :answer, :govuk_summary_list_col
        end
        section :other_known_claimants, :govuk_summary_list_row, :'review.claim_details.questions.other_known_claimants' do
          element :answer, :govuk_summary_list_col
        end
        section :attached_documents, :govuk_summary_list_row, :'review.claim_details.questions.attached_documents' do
          element :answer, :govuk_summary_list_col
        end
      end
      section :claim_outcome_section, :govuk_summary_list, :'review.claim_outcome.title' do
        section :what_outcome, :govuk_summary_list_row, :'review.claim_outcome.questions.what_outcome' do
          element :answer, :govuk_summary_list_col
        end
        section :outcome_details, :govuk_summary_list_row, :'review.claim_outcome.questions.outcome_details' do
          element :answer, :govuk_summary_list_col
        end
      end
      section :claim_type_section, :govuk_summary_list, :'review.claim_type.title' do
        section :send_to_whistleblowing_body, :govuk_summary_list_row, :'review.claim_type.questions.send_to_whistleblowing_body' do
          element :answer, :govuk_summary_list_col
        end
        section :whistleblowing, :govuk_summary_list_row, :'review.claim_type.questions.whistleblowing' do
          element :answer, :govuk_summary_list_col
        end
        section :types, :govuk_summary_list_row, :'review.claim_type.questions.types' do
          element :answer, :govuk_summary_list_col
        end
      end
      section :claimant_section, :govuk_summary_list, :'review.claimant.title' do
        section :date_of_birth, :govuk_summary_list_row, :'review.claimant.questions.date_of_birth' do
          element :answer, :govuk_summary_list_col
        end
        section :preferred_contact, :govuk_summary_list_row, :'review.claimant.questions.preferred_contact' do
          element :answer, :govuk_summary_list_col
        end
        section :allow_phone_or_video_attendance, :govuk_summary_list_row, :'review.claimant.questions.allow_phone_or_video_attendance' do
          element :answer, :govuk_summary_list_col
        end
        section :address, :govuk_summary_list_row, :'review.claimant.questions.address' do
          element :answer, :govuk_summary_list_col
        end
        section :email, :govuk_summary_list_row, :'review.claimant.questions.email' do
          element :answer, :govuk_summary_list_col
        end
        section :assistance_required, :govuk_summary_list_row, :'review.claimant.questions.assistance_required' do
          element :answer, :govuk_summary_list_col
        end
        section :full_name, :govuk_summary_list_row, :'review.claimant.questions.full_name' do
          element :answer, :govuk_summary_list_col
        end
        section :mobile, :govuk_summary_list_row, :'review.claimant.questions.mobile' do
          element :answer, :govuk_summary_list_col
        end
        section :phone, :govuk_summary_list_row, :'review.claimant.questions.phone' do
          element :answer, :govuk_summary_list_col
        end
        section :gender, :govuk_summary_list_row, :'review.claimant.questions.gender' do
          element :answer, :govuk_summary_list_col
        end
      end
      section :employment_section, :govuk_summary_list, :'review.employment.title' do
        section :pension_scheme, :govuk_summary_list_row, :'review.employment.questions.pension_scheme' do
          element :answer, :govuk_summary_list_col
        end
        section :notice_period, :govuk_summary_list_row, :'review.employment.questions.notice_period' do
          element :answer, :govuk_summary_list_col
        end
        section :end_date, :govuk_summary_list_row, :'review.employment.questions.end_date' do
          element :answer, :govuk_summary_list_col
        end
        section :start_date, :govuk_summary_list_row, :'review.employment.questions.start_date' do
          element :answer, :govuk_summary_list_col
        end
        section :pay_before_tax, :govuk_summary_list_row, :'review.employment.questions.pay_before_tax' do
          element :answer, :govuk_summary_list_col
        end
        section :pay_after_tax, :govuk_summary_list_row, :'review.employment.questions.pay_after_tax' do
          element :answer, :govuk_summary_list_col
        end
        section :average_weekly_hours_worked, :govuk_summary_list_row, :'review.employment.questions.average_weekly_hours_worked' do
          element :answer, :govuk_summary_list_col
        end
        section :current_situation, :govuk_summary_list_row, :'review.employment.questions.current_situation' do
          element :answer, :govuk_summary_list_col
        end
        section :job, :govuk_summary_list_row, :'review.employment.questions.job' do
          element :answer, :govuk_summary_list_col
        end
        section :benefit_details, :govuk_summary_list_row, :'review.employment.questions.benefit_details' do
          element :answer, :govuk_summary_list_col
        end
        section :another_job, :govuk_summary_list_row, :'review.employment.questions.another_job' do
          element :answer, :govuk_summary_list_col
        end
        section :notice_pay, :govuk_summary_list_row, :'review.employment.questions.notice_pay' do
          element :answer, :govuk_summary_list_col
        end
        section :notice_period_end_date, :govuk_summary_list_row, :'review.employment.questions.notice_period_end_date' do
          element :answer, :govuk_summary_list_col
        end
        section :pay_before_tax_at_new_job, :govuk_summary_list_row, :'review.employment.questions.pay_before_tax_at_new_job' do
          element :answer, :govuk_summary_list_col
        end
        section :employed_by_employer, :govuk_summary_list_row, :'review.employment.questions.employed_by_employer' do
          element :answer, :govuk_summary_list_col
        end
      end
      section :representative_section, :govuk_summary_list, :'review.representative.title' do
        section :type_of_representative, :govuk_summary_list_row, :'review.representative.questions.type_of_representative' do
          element :answer, :govuk_summary_list_col
        end
        section :email, :govuk_summary_list_row, :'review.representative.questions.email' do
          element :answer, :govuk_summary_list_col
        end
        section :address, :govuk_summary_list_row, :'review.representative.questions.address' do
          element :answer, :govuk_summary_list_col
        end
        section :full_name, :govuk_summary_list_row, :'review.representative.questions.full_name' do
          element :answer, :govuk_summary_list_col
        end
        section :dx_number, :govuk_summary_list_row, :'review.representative.questions.dx_number' do
          element :answer, :govuk_summary_list_col
        end
        section :mobile, :govuk_summary_list_row, :'review.representative.questions.mobile' do
          element :answer, :govuk_summary_list_col
        end
        section :preferred_contact, :govuk_summary_list_row, :'review.representative.questions.preferred_contact' do
          element :answer, :govuk_summary_list_col
        end
        section :phone, :govuk_summary_list_row, :'review.representative.questions.phone' do
          element :answer, :govuk_summary_list_col
        end
        section :organisation_name, :govuk_summary_list_row, :'review.representative.questions.organisation_name' do
          element :answer, :govuk_summary_list_col
        end
        section :representative, :govuk_summary_list_row, :'review.representative.questions.representative' do
          element :answer, :govuk_summary_list_col
        end
      end
      section :respondent_section, :govuk_summary_list, :'review.respondent.title' do
        section :name, :govuk_summary_list_row, :'review.respondent.questions.name' do
          element :answer, :govuk_summary_list_col
        end
        section :address, :govuk_summary_list_row, :'review.respondent.questions.address' do
          element :answer, :govuk_summary_list_col
        end
        section :phone, :govuk_summary_list_row, :'review.respondent.questions.phone' do
          element :answer, :govuk_summary_list_col
        end
        section :acas_number, :govuk_summary_list_row, :'review.respondent.questions.acas_number' do
          element :answer, :govuk_summary_list_col
        end
        section :work_address, :govuk_summary_list_row, :'review.respondent.questions.work_address' do
          element :answer, :govuk_summary_list_col
        end
      end
      section :email_confirmation_section, :fieldset_translated, 'review.email_confirmation.title' do
        include EtTestHelpers::Section

        # @!method email_recipients
        #   A govuk collection of checkboxes component for unfair dismissal question
        #   @return [EtTestHelpers::Components::GovUKCollectionCheckBoxes] The site prism section
        gds_checkboxes :email_recipients, :'review.email_confirmation.email_recipients'
      end
      def edit_section(section_name)
        query = XPath.generate { |x| x.descendant(:a)[x.string.n.equals("Edit #{section_name} answers")] }
        find(:xpath, query).click
      end
    end
  end
end
