class ConfirmationEmailPreview < ActionMailer::Preview
  [:payment_no_remission, :remission_only, :group_payment_with_remission, :payment_no_remission_payment_failed, :group_payment_with_remission_payment_failed].each do |claim_scenario|
    define_method(claim_scenario) { claim_for claim_scenario }
  end

  private

  def claim_for(trait)
    claim = FactoryGirl.create(:claim, :with_pdf, trait)
    mail  = BaseMailer.confirmation_email(claim)

    multipart_preview_fix(mail)
  end

  def multipart_preview_fix(mail)
    mail.tap do |m|
      true_mail_parts = m.parts.find(&:multipart?).body.parts
      { 'text_part=' => /text\/plain/, 'html_part=' => /text\/html/ }.each do |mutator, content_match|
        m.send(mutator, true_mail_parts.find { |p| p.content_type =~ content_match })
      end
    end
  end
end
