class GuidesController < MarkdownController
  add_markdown_path   Rails.root.join(*%w<app views guides markdown>)
  add_markdown_files  %w<payments_from_ni_fund time_limits acas_early_conciliation acas_early_conciliation_exceptions fees_and_payment fees_and_payment_working_out_your_fee fees_and_payment_paying_your_fee reducing_fees writing_your_claim_statement>

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
