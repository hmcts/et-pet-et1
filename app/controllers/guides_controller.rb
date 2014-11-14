class GuidesController < MarkdownController
  add_markdown_path   Rails.root.join(*%w<app views guides markdown>)
  add_markdown_files  %w<fees help_with_paying_the_fees acas_early_conciliation
                        writing_your_claim_statement>
end
