module ClaimReviewsHelper
  def incomplete_claim_warning
    unless claim.submittable?
      render partial: 'error_header', locals: {
        summary: t('claim_review.incomplete_claim_summary'),
        message: t('claim_review.incomplete_claim_message')
      }
    end
  end
end
