class GuidesController < ApplicationController

  MARKDOWN_DIRECTORY = Rails.root.join( *%w<app views guides markdown> ).freeze
  MARKDOWN_FILES = %w<fees acas_early_conciliation writing_your_claim_statement>.freeze
  EXTENSION = ".md".freeze

  RENDERER_INSTANCE = MarkdownRenderer.new

  def show
    @guide_presenter = GuidePresenter.new( markdown_files, RENDERER_INSTANCE )
  end

  private
  helper_method def markdown_files
    MARKDOWN_FILES.map { |name| "#{ MARKDOWN_DIRECTORY.join(name + EXTENSION) }" }
  end

end
