module Messages
  def claim_heading_for(page)
    I18n.t("claims.#{page}.header")
  end

  def review_heading_for(page)
    I18n.t("claim_reviews.#{page}.header")
  end
end
