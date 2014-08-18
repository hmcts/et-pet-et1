module ClaimReviewsHelper
  def incomplete_claim_warning
    unless claim.submittable?
      content_tag(:div, class: 'incomplete-claim') { t 'claim_review.incomplete_claim' }
    end
  end
end
