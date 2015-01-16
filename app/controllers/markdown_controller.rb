class MarkdownController < ActionController::Base
  include SignoutVisibility

  layout 'application'

  RENDERER_INSTANCE = MarkdownRenderer.new

  class << self
    attr_accessor :markdown_path, :markdown_files
    alias_method  :add_markdown_path, :markdown_path=
    alias_method  :add_markdown_files, :markdown_files=
  end

  def show
    @presenter = GuidePresenter.new(markdown_files, RENDERER_INSTANCE)
  end

  private

  def markdown_files
    self.class.markdown_files.map do |name|
      "#{ self.class.markdown_path.join(name + '.md') }"
    end
  end
end
