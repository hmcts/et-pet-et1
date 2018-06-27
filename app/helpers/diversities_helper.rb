module DiversitiesHelper
  delegate :current_page, :total_pages, to: :page_manager

  def format(text)
    markdown.render(text)
  end

  def diversity_header
    I18n.t("diversities.#{current_step}.header")
  end

  def diversity_title
    page_title(diversity_header)
  end

  private

  def markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end
end
