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

  private

  def markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end
end
