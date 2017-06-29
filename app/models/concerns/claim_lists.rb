module ClaimLists

  DISCRIMINATION_COMPLAINTS = %i[
    sex_including_equal_pay disability race age
    pregnancy_or_maternity religion_or_belief sexual_orientation
    marriage_or_civil_partnership gender_reassignment
  ].freeze

  PAY_COMPLAINTS = %i[redundancy notice holiday arrears other].freeze

  DESIRED_OUTCOMES = %i[
    compensation_only tribunal_recommendation
    reinstated_employment_and_compensation
    new_employment_and_compensation
  ].freeze

end
