module RefundsHelper
  delegate :current_page, :total_pages, to: :page_manager

  def format(text)
    markdown.render(text)
  end

  def refund_header
    I18n.t("refunds.#{current_step}.header")
  end

  def refund_title
    page_title(refund_header)
  end

  private def markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end
end
