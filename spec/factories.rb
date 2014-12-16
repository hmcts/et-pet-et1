FactoryGirl.define do
  factory :claim do
    association :primary_claimant,   factory: :claimant, primary_claimant: true
    association :primary_respondent, factory: :respondent, primary_respondent: true
    association :representative
    association :employment
    association :payment
    association :office

    state 'enqueued_for_submission'

    is_unfair_dismissal true

    additional_information_rtf do
      Rack::Test::UploadedFile.new 'spec/support/files/file.rtf'
    end

    additional_claimants_csv do
      Rack::Test::UploadedFile.new 'spec/support/files/file.csv'
    end

    fee_group_reference { "%010d00" % rand(9999999999) }

    claim_details       'I am sad'
    other_claim_details 'Really sad'
    other_outcome       'I wanna take him to the cleaners!'
    is_whistleblowing   false

    discrimination_claims  %i<sex_including_equal_pay disability race>
    pay_claims             %i<redundancy notice holiday arrears other>
    desired_outcomes       %i<compensation_only tribunal_recommendation>

    submitted_at { Time.now }

    trait :without_additional_claimants_csv do
      additional_claimants_csv nil
    end

    trait :without_representative do
      representative nil
    end

    trait :with_pdf do
      after(:create) { |claim| claim.generate_pdf! }
    end

    trait :payment_no_remission do
      remission_claimant_count 0
    end

    trait :remission_only do
      remission_claimant_count 1
      payment nil
    end

    trait :group_payment_with_remission do
      remission_claimant_count 2
      after(:create) { |claim| create_list :claimant, 2, claim: claim }
    end

    trait :payment_no_remission_payment_failed do
      remission_claimant_count 0
      payment nil
    end

    trait :group_payment_with_remission_payment_failed do
      remission_claimant_count 2
      payment nil
      after(:create) { |claim| create_list :claimant, 2, claim: claim }
    end
  end

  factory :claimant do
    association :address, country: 'United Kingdom'

    title      'mr'
    first_name 'Barrington'
    last_name  'Wrigglesworth'
    gender     'male'

    date_of_birth Date.civil(1960, 6, 6)

    mobile_number      '07956273434'
    contact_preference 'email'
    email_address      { "#{first_name}.#{last_name}@example.com" }
  end

  factory :address do
    building  '102'
    street    'Petty France'
    locality  'London'
    county    'Greater London'
    post_code 'SW1A 1AH'

    telephone_number '020 7123 4567'
  end

  factory :representative do
    association :address

    type              "law_centre"
    name              "Saul Goodman"
    organisation_name "Better Call Saul"
    dx_number         "1234"
  end

  factory :respondent do
    name                    "Ministry of Justice"
    no_acas_number_reason   "employer_contacted_acas"
    worked_at_same_address  false
    addresses               { create_list(:address, 2) }
  end

  factory :payment do
    amount 250
    reference { rand 99999999 }
  end

  factory :office do
    name      "Birmingham"
    address   "Centre City Tower, 5­7 Hill Street, Birmingham B5 4UU"
    telephone "0121 600 7780"
  end

  factory :employment do
    enrolled_in_pension_scheme           true
    found_new_job                        false
    worked_notice_period_or_paid_in_lieu false
    end_date                             { 3.weeks.ago }
    new_job_start_date                   { 3.days.ago }
    start_date                           { 10.years.ago }
    gross_pay                            4000
    net_pay                              3000
    new_job_gross_pay                    4000
    average_hours_worked_per_week        37.5
    current_situation                    "employment_terminated"
    gross_pay_period_type                "monthly"
    job_title                            "tea boy"
    net_pay_period_type                  "monthly"
    benefit_details                      "All the justice you can eat"
  end
end
