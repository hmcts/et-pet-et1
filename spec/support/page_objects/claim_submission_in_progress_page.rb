require_relative './base_page'
module ET1
  module Test
    class ClaimSubmissionInProgressPage < BasePage
      set_url "/en/apply/review/in_progress"

      element :header, 'h1.govuk-heading-xl'
      element :error_description, '.content-body p.govuk-body'
      element :what_happens_next_header, 'h2.govuk-heading-m'
      elements :what_happens_next_items, '.govuk-list--bullet li.govuk-body'
      element :process_questions_header, 'h2.govuk-heading-m'
      element :process_questions_content, '.content-body p.govuk-body'
      element :submission_feedback_header, 'h2.govuk-heading-m strong'
      element :feedback_content, '.content-body p.govuk-body'
      element :feedback_link, '.govuk-button--start'

      def has_meta_refresh?
        page.has_css?('meta[http-equiv="refresh"]', visible: false)
      end

      def meta_refresh_content
        page.find('meta[http-equiv="refresh"]', visible: false)['content']
      end
    end
  end
end
