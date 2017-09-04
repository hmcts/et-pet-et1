module Refunds
  class OriginalCaseDetailsForm < Form
    attribute :et_reference_number,         String
    attribute :et_case_number,              String
    attribute :et_tribunal_office,          String
    attribute :respondent_name,             String
    attribute :respondent_post_code,        String
    attribute :claimant_title,              String
    attribute :claimant_first_name,         String
    attribute :claimant_last_name,          String
    attribute :claimant_national_insurance, String
    attribute :claimant_date_of_birth,      Date
    attribute :extra_reference_numbers,     String
  end
end
