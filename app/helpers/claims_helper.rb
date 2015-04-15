module ClaimsHelper
  delegate :current_page, :total_pages, to: :page_manager

  def format(text)
    markdown.render(text).html_safe
  end

  def claim_header
    I18n.t("claims.#{current_step}.header")
  end

  def claim_title
    page_title(claim_header)
  end

  def claim_actions
    %i<application_number claimant additional_claimants
      representative respondent additional_respondents
      employment claim_type claim_details claim_outcome
      additional_information your_fee>
  end

  private def markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end
end
