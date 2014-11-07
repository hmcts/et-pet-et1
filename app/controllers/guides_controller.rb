class GuidesController < ApplicationController
  skip_before_action :ensure_claim_exists

  MARKDOWN_DIRECTORY = Rails.root.join( *%w<app views guides markdown> ).freeze
  MARKDOWN_FILES = %w<fees help_with_paying_the_fees acas_early_conciliation writing_your_claim_statement>.freeze
  EXTENSION = ".md".freeze

  RENDERER_INSTANCE = MarkdownRenderer.new

  def show
    @guide_presenter = GuidePresenter.new( markdown_files, RENDERER_INSTANCE )
  end

  private

  def markdown_files
    MARKDOWN_FILES.map { |name| "#{ MARKDOWN_DIRECTORY.join(name + EXTENSION) }" }
  end

  helper_method :markdown_files
end
