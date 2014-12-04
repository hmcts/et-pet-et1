class GuidesController < MarkdownController
  before_action :hide_mobile_nav
  add_markdown_path   Rails.root.join(*%w<app views guides markdown>)
  add_markdown_files  %w<time_limits acas_early_conciliation acas_early_conciliation_exceptions fees_and_payment fees_and_payment_working_out_your_fee fees_and_payment_paying_your_fee reducing_fees writing_your_claim_statement>
end
