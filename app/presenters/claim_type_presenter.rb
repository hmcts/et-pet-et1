class ClaimTypePresenter < Presenter
  def types
    claims = []

    if is_unfair_dismissal
      claims << I18n.t("simple_form.labels.claim_type.is_unfair_dismissal")
    end

    if is_protective_award
      claims << I18n.t("simple_form.labels.claim_type.is_protective_award")
    end

    claims.push(*pay_claims)

    claims.push(*discrimination_claims)

    claims.join(tag(:br))
  end

  def is_whistleblowing
    yes_no target.is_whistleblowing
  end

  def send_claim_to_whistleblowing_entity
    yes_no target.send_claim_to_whistleblowing_entity
  end

  private

  def discrimination_claims
    target.discrimination_claims.map do |c|
      I18n.t "simple_form.options.claim_type.discrimination_claims_for_review.#{c}"
    end
  end

  def pay_claims
    target.pay_claims.map do |c|
      I18n.t "simple_form.options.claim_type.pay_claims.#{c}"
    end
  end
end
