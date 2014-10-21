module ClaimsHelper
  def format(text)
    markdown.render(text).html_safe
  end

  def claim_header
    I18n.t("claims.#{current_step}.header")
  end

  def current_page
    transition_manager.current_page
  end

  def total_pages
    transition_manager.total_pages
  end

  private def markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end
end
