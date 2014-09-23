module Messages
  include ClaimsHelper

  def claim_heading_for(page)
    I18n.t("claims.#{page}.header")
  end

  def review_heading_for(page)
    I18n.t("claim_reviews.#{page}.header")
  end

  def completion_message(reference)
    format I18n.t('claim_reviews.confirmation.complete', reference: reference)
  end
end
