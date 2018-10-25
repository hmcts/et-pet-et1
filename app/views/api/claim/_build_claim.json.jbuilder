json.uuid SecureRandom.uuid
json.command 'BuildClaim'
json.data do
  json.reference claim.fee_group_reference
  json.submission_reference claim.reference
  json.submission_channel 'Web'
  json.case_type claim.multiple_claimants? ? 'Multiple' : 'Single'
  json.jurisdiction claim.attracts_higher_fee? ? 2 : 1
  json.office_code office.try(:code)
  json.date_of_receipt claim.submitted_at
  json.other_known_claimant_names claim.other_known_claimant_names
  json.is_unfair_dismissal claim.is_unfair_dismissal
  json.discrimination_claims do
    json.array! claim.discrimination_claims.map(&:to_s)
  end
  json.pay_claims do
    json.array! claim.pay_claims.map(&:to_s)
  end
  json.desired_outcomes do
    json.array! claim.desired_outcomes.map(&:to_s)
  end
  json.other_claim_details claim.other_claim_details
  json.claim_details claim.claim_details
  json.other_outcome claim.other_outcome
  json.send_claim_to_whistleblowing_entity claim.send_claim_to_whistleblowing_entity

  if employment.nil?
    json.employment_details({})
  else
    json.employment_details do
      json.start_date employment.start_date
      json.end_date employment.end_date
      json.notice_period_end_date employment.notice_period_end_date
      json.job_title employment.job_title
      json.average_hours_worked_per_week employment.average_hours_worked_per_week
      json.gross_pay employment.gross_pay
      json.gross_pay_period_type employment.gross_pay_period_type
      json.net_pay employment.net_pay
      json.net_pay_period_type employment.net_pay_period_type
      json.worked_notice_period_or_paid_in_lieu employment.worked_notice_period_or_paid_in_lieu
      json.notice_pay_period_type employment.notice_pay_period_type
      json.notice_pay_period_count employment.notice_pay_period_count
      json.enrolled_in_pension_scheme employment.enrolled_in_pension_scheme
      json.benefit_details employment.benefit_details
      json.found_new_job employment.found_new_job
      json.new_job_start_date employment.new_job_start_date
      json.new_job_gross_pay employment.new_job_gross_pay
    end
  end
end