module ClaimsHelper
  delegate :current_page, :total_pages, to: :page_manager

  def format(text)
    markdown.render(text)
  end

  def claim_header
    I18n.t("claims.#{current_step}.header")
  end

  def claim_title
    page_title(claim_header)
  end

  def responses_collection
    [[t('.true'), true], [t('.false'), false]]
  end

  def language_specific_feedback_url
    if I18n.locale.to_s == 'en'
      return 'https://www.gov.uk/done/employment-tribunals-make-a-claim'
    end
    feedback_url(locale: I18n.locale)
  end

  def group_claim_template_file_path
    if I18n.locale.to_s == 'cy'
      "/assets/group-claims-template-cy.csv"
    else
      "/assets/group-claims-template.csv"
    end
  end

  private def markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end
end
