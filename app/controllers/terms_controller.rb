class TermsController < ApplicationController
  skip_before_action :ensure_claim_exists

  MARKDOWN_DIRECTORY = Rails.root.join(*%w<app views terms markdown>).freeze
  MARKDOWN_FILES = %w<general applicable_law privacy_policy data_protection disclaimer>.freeze
  EXTENSION = ".md".freeze

  RENDERER_INSTANCE = MarkdownRenderer.new

  def show
    @terms_presenter = GuidePresenter.new(markdown_files, RENDERER_INSTANCE)
  end

  private

  def markdown_files
    MARKDOWN_FILES.map { |name| "#{ MARKDOWN_DIRECTORY.join(name + EXTENSION) }" }
  end

  helper_method :markdown_files
end
