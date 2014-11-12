class ClaimOutcomePresenter < Presenter
  def desired_outcomes
    target.desired_outcomes.
      map { |c| I18n.t "simple_form.options.claim.desired_outcomes.#{c}" }.
      join('<br />').html_safe
  end

  def other_outcome
    simple_format target.other_outcome
  end
end
