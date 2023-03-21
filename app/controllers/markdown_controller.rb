class MarkdownController < ApplicationController
  layout 'application'

  RENDERER_INSTANCE = MarkdownRenderer.new

  class << self
    attr_accessor :markdown_path, :markdown_files
    alias add_markdown_path markdown_path=
    alias add_markdown_files markdown_files=

    def views_term_markdowdon_link
      arr = ['app', 'views', 'terms', 'markdown']
      Rails.root.join(*arr)
    end

    def views_guides_markdowdon_link
      arr = ['app', 'views', 'guides', 'markdown']
      Rails.root.join(*arr)
    end

    def views_guides_cookies_link
      arr = ['app', 'views', 'cookies', 'markdown']
      Rails.root.join(*arr)
    end
  end

  def show
    @presenter = GuidePresenter.new(markdown_files, RENDERER_INSTANCE)
  end

  private

  def markdown_files
    self.class.markdown_files.map do |name|
      self.class.markdown_path.join("#{name}.md").to_s
    end
  end
end
