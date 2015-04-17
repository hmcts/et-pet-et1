class ClaimTypePresenceValidator < ActiveModel::Validator
  def validate(form)
    unless single_choice_selected?(form) || multiple_choice_selected?(form)
      form.errors.add(:base, :invalid)
    end
  end

  private

  def single_choice_selected?(form)
    %i<is_unfair_dismissal is_other_type_of_claim is_whistleblowing>.
      find { |predicate| form.send predicate }
  end

  def multiple_choice_selected?(form)
    [*form.pay_claims, *form.discrimination_claims].reject(&:blank?).any?
  end
end
