module ClaimsHelper
  def format(text, options = {})
    Markdown.new(text, options).to_html.html_safe
  end

  def claim_header
    I18n.t("claims.#{current_step}.header")
  end
end
