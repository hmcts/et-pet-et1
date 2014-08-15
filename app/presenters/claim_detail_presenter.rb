class ClaimDetailPresenter < Presenter
  def types
    claims = []

    if is_unfair_dismissal
      claims << I18n.t("simple_form.labels.claim.is_unfair_dismissal")
    end

    # %i<pay_claims discrimination_claims>.each_with_object(claims) do |section, claims|
    #   collection = target.send(section)
    #   next unless collection
    #
    #   claims.push *collection.
    #     map { |c| I18n.t "simple_form.options.claim.#{section}.#{c}" }
    # end

    target.pay_claims.each_with_object(claims) do |claim, claims|
      claims << I18n.t("simple_form.options.claim.pay_claims.#{claim}")
    end

    target.discrimination_claims.each_with_object(claims) do |claim, claims|
      claims << I18n.t("simple_form.options.claim.discrimination_claims.#{claim}")
    end

    # claims.push *target.pay_claims.
    #   map { |c| I18n.t "simple_form.options.claim.pay_claims.#{c}" }
    #
    # claims.push *target.discrimination_claims.
    #   map { |c| I18n.t "simple_form.options.claim.discrimination_claims.#{c}" }

    claims.join('<br />').html_safe
  end

  def claim_details
    simple_format target.claim_details
  end

  def desired_outcomes
    target.desired_outcomes.
      map { |c| I18n.t "simple_form.options.claim.desired_outcomes.#{c}" }.
      join('<br />').html_safe
  end

  def other_outcome
    simple_format target.other_outcome
  end

  def other_known_claimant_names
    simple_format target.other_known_claimant_names
  end

  def is_whistleblowing
    yes_no target.is_whistleblowing
  end

  def send_claim_to_whistleblowing_entity
    yes_no target.send_claim_to_whistleblowing_entity
  end

  def miscellaneous_information
    simple_format target.miscellaneous_information
  end
end
