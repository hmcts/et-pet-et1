class GuidesController < MarkdownController
  add_markdown_path views_guides_markdowdon_link
  add_markdown_files %w[
    time_limits acas_early_conciliation
    acas_early_conciliation_exceptions
    writing_your_claim_statement
  ]

  delegate :referrer, :host, to: :request

  def return_to_form
    if referrer && host == URI.parse(referrer).host
      referrer
    else
      apply_path
    end
  end

  helper_method :return_to_form
end
