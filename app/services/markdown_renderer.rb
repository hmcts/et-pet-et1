class MarkdownRenderer
  def initialize
    @renderer = setup_redcarpet_renderer
  end

  def render(contents)
    @renderer.render(contents).html_safe
  end

  private def setup_redcarpet_renderer
    renderer = Redcarpet::Render::HTML.new
    return Redcarpet::Markdown.new(renderer, tables: true)
  end
end