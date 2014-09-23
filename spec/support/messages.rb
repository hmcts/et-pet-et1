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

  def payment_message
    format I18n.t('claim_reviews.confirmation.fee_paid')
  end

  def remission_help
    format I18n.t('claim_reviews.confirmation.remission_help')
  end

  def table_heading(heading)
    I18n.t("claim_reviews.confirmation.details.#{heading}")
  end
end
