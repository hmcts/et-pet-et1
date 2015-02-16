module ClaimReviewsHelper
  def incomplete_claim_warning
    unless claim.submittable?
      render partial: 'error_header', locals: {
        summary: t('.incomplete_claim_summary'),
        message: t('.incomplete_claim_message')
      }
    end
  end

  def review_header
    I18n.t("#{current_step}.header")
  end

  def email_addresses
    claimants = claim.claimants.pluck(:email_address)
    representatives = [claim.representative.try(:email_address)]

    (claimants + representatives).reject(&:blank?)
  end

  def claim_presenter
    @claim_presenter ||= ClaimPresenter.new(claim)
  end

  def confirmation_email
    @confirmation_email ||= ConfirmationEmail.new
  end

  def quick_edit_link_for(section)
    link_to t('.edit'), claim_path_for(section, return_to_review: true)
  end

  def submit_button_text
    if claim.remission_applicable?
      t '.submit_with_remission'
    else
      t '.submit_go_to_payment'
    end
  end
end
