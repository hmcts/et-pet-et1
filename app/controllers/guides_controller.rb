class GuidesController < ApplicationController
  def show
    markup_directory = Rails.root.join( *%w{ app views guides markdown } )

    files = %w{
      fees
      acas_early_conciliation
      writing_your_claim_statement
    }

    @guide_presenter = GuidePresenter.new( markup_directory, files, MarkdownRenderer.new )
  end
end
