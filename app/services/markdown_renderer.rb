class MarkdownRenderer
  def initialize
    @renderer = setup_redcarpet_renderer
  end

  # rubocop:disable Rails/OutputSafety
  def render(contents)
    @renderer.render(contents).html_safe
  end
  # rubocop:enable Rails/OutputSafety

  private def setup_redcarpet_renderer
    html_renderer = Redcarpet::Render::HTML.new
    Redcarpet::Markdown.new(html_renderer, tables: true)
  end
end
