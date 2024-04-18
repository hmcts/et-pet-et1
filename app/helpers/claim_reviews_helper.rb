module ClaimReviewsHelper
  def incomplete_claim_warning(claim)
    return if claim.submittable?

    render partial: 'error_header', locals: {
      summary: t('.incomplete_claim_summary'),
      message: t('.incomplete_claim_message')
    }
  end

  def claim_presenter
    @claim_presenter ||= ClaimPresenter.new(claim)
  end

  def confirmation_email(claim)
    @confirmation_email ||= ConfirmationEmail.new(claim)
  end

  def submit_button_text(_claim)
    t '.submit'
  end

  def review_date(date)
    return date if date.nil?

    I18n.l date, format: '%d %B %Y'
  end

  def review_pay_for(pay, period)
    return unless [pay, period].all?(&:present?)

    "#{number_to_currency(pay)} #{t("claim_reviews.item.employment.pay_period_#{period}")}"
  end

  def review_types(claim)
    claims = []

    claims << I18n.t("claims.claim_type.is_unfair_dismissal.options.1") if claim.is_unfair_dismissal?

    claims.push(*claim.pay_claims.map { |c| I18n.t "claims.claim_type.pay_claims.options.#{c}" })

    claims.push(*claim.discrimination_claims.map { |c| I18n.t "claim_reviews.discrimination_claims.#{c}" })

    claims.push(t("claims.claim_type.is_other_type_of_claim.options.true")) if claim.is_other_type_of_claim?

    claims.join(tag.br).html_safe
  end

  def review_claimant_full_name(claimant)
    salutation = t("claims.personal_details.title.options.#{claimant.title}") unless claimant.title.nil?
    [salutation, claimant.first_name, claimant.last_name].compact.join ' '
  end

end
