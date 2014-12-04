class MarkdownController < ActionController::Base
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

  def show_mobile_nav?
    !@hide_mobile_nav
  end

  def hide_mobile_nav
    @hide_mobile_nav = true
  end

  helper_method :show_mobile_nav?, :show_signout?
end
