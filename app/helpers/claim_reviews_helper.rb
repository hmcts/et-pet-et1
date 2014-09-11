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
end
