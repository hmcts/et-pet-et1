class ConfirmationEmailPreview < ActionMailer::Preview
  def payment_no_remission
    claim_for :payment_no_remission
  end

  def remission_only
    claim_for :remission_only
  end

  def group_payment_with_remission
    claim_for :group_payment_with_remission
  end

  def payment_no_remission_payment_failed
    claim_for :payment_no_remission_payment_failed
  end

  def group_payment_with_remission_payment_failed
    claim_for :group_payment_with_remission_payment_failed
  end

  private def claim_for(trait, email='user@example.com')
    claim = FactoryGirl.create(:claim, trait)
    BaseMailer.confirmation_email(claim, email)
  end
end
