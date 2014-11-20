class GuidesController < MarkdownController
  add_markdown_path   Rails.root.join(*%w<app views guides markdown>)
  add_markdown_files  %w<time_limits fees_and_payment reducing_fees acas_early_conciliation writing_your_claim_statement>
end
