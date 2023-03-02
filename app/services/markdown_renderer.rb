class MarkdownRenderer
  def initialize
    @renderer = setup_redcarpet_renderer
  end

  def render(contents)
    @renderer.render(contents).html_safe
  end

  private

  def setup_redcarpet_renderer
    html_renderer = Redcarpet::Render::HTML.new
    Redcarpet::Markdown.new(html_renderer, tables: true)
  end
end
