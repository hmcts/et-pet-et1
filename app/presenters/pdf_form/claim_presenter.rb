class PdfForm::ClaimPresenter < PdfForm::BaseDelegator
  present :office, :primary_claimant, :representative, :employment

  delegate :name, to: :primary_claimant

  def respondents
    super.map.with_index do |respondent, i|
      PdfForm::RespondentPresenter.new(respondent, i)
    end
  end

  def to_h
    presenters = [office, claim, primary_claimant, representative, employment] + respondents
    presenters.each_with_object({}) { |p, o| o.update p.to_h }
  end

  [:other_outcome, :claim_details, :other_claim_details, :miscellaneous_information].each do |name|
    define_method(name) { sanitize_text super() }
  end

  private

  def sanitize_text(str)
    if str
      str.gsub(/(\r?\n){2,}/, "\n\n").  # replace extraneous whitespace
        gsub(/[\u201c\u201d]/, '"').    # replace left & right double quotes
        gsub(/[\u2019]/, "'")           # replace right single quotes
    end
  end

  def owed?
    claim_types = Claim::PAY_COMPLAINTS - [:redundancy]
    claim_types.any? { |type| pay_claims.include? type }
  end

  def type_of_claim
    if multiple_claimants?
      'a claimon behalf of more than one person'
    else
      'a single claim'
    end
  end

  def number_of_claimants
    claimant_count if multiple_claimants?
  end

  # rubocop:disable MethodLength
  # rubocop:disable Metrics/AbcSize
  def claim
    {
      "type of claim" => type_of_claim,
      "more than one claimant" => number_of_claimants,
      "date received" => format_date(submitted_at),
      "2.4 tick box" => dual_state(respondents.count > 1),
      "3.1 tick boxes" => tri_state(other_known_claimant_names.present?),
      "3.1 if yes" => other_known_claimant_names,

      "8.1 unfairly tick box" => dual_state(is_unfair_dismissal),
      "8.1 discriminated" => dual_state(discrimination_claims?),
      "8.1 age" => dual_state(discrimination_claims?(:age)),
      "8.1 race" => dual_state(discrimination_claims?(:race)),
      "8.1 gender reassignment" => dual_state(discrimination_claims?(:gender_reassignment)),
      "8.1 disability" => dual_state(discrimination_claims?(:disability)),
      "8.1 pregnancy" => dual_state(discrimination_claims?(:pregnancy_or_maternity)),
      "8.1 marriage" => dual_state(discrimination_claims?(:marriage_or_civil_partnership)),
      "8.1 sexual orientation" => dual_state(discrimination_claims?(:sexual_orientation)),
      "8.1 sex" => dual_state(discrimination_claims?(:sex_including_equal_pay)),
      "8.1 religion" => dual_state(discrimination_claims?(:religion_or_belief)),
      "8.1 redundancy" => dual_state(pay_claims?(:redundancy)),
      "8.1 owed" => dual_state(owed?),
      "8.1 notice pay" => dual_state(pay_claims?(:notice)),
      "8.1 holiday pay" => dual_state(pay_claims?(:holiday)),
      "8.1 arrears of pay" => dual_state(pay_claims?(:arrears)),
      "8.1 other payments" => dual_state(pay_claims?(:other)),
      "8.1 another type of claim" => dual_state(other_claim_details.present?),
      "8.1 other type of claim" => other_claim_details,
      "8.2" => claim_details,

      "9.1 old job back" => dual_state(desired_outcomes?(:reinstated_employment_and_compensation)),
      "9.1 another job" => dual_state(desired_outcomes?(:new_employment_and_compensation)),
      "9.1 compensation" => dual_state(desired_outcomes?(:compensation_only)),
      "9.1 recommendation" => dual_state(desired_outcomes?(:tribunal_recommendation)),
      "9.2" => other_outcome,
      "10.1" => dual_state(send_claim_to_whistleblowing_entity?),

      "15" => miscellaneous_information
    }
  end
  # rubocop:enable MethodLength
  # rubocop:enable Metrics/AbcSize

end
