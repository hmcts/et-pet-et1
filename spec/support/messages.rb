module Messages
  include ClaimsHelper

  def page_number(page)
    I18n.t('claims.show.page_number', current_page: page, total_pages: 11)
  end

  def before_you_start_message
    'Saving your claim'
  end

  def claim_heading_for(page)
    I18n.t("claims.#{page}.header")
  end

  def review_heading_for(page)
    I18n.t("claim_reviews.#{page}.header")
  end

  def completion_message
    I18n.t('claim_reviews.confirmation.header')
  end

  def table_heading(heading)
    I18n.t("claim_reviews.confirmation.details.#{heading}")
  end
end
