module ClaimsHelper
  def format(text)
    markdown.render(text).html_safe
  end

  def claim_header
    I18n.t("claims.#{current_step}.header")
  end

  private def markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end
end
