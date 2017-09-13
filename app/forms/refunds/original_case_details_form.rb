module Refunds
  class OriginalCaseDetailsForm < Form
    PAYMENT_METHODS = ['card', 'cheque', 'cash']
    attribute :et_case_number,                    String
    attribute :et_tribunal_office,                String
    attribute :respondent_name,                   String
    attribute :respondent_post_code,              String
    attribute :representative_name,               String
    attribute :representative_post_code,          String
    attribute :additional_information,            String
    attribute :et_issue_fee,                      Float
    attribute :et_issue_fee_payment_method,       String
    attribute :et_hearing_fee,                    Float
    attribute :et_hearing_fee_payment_method,     String
    attribute :eat_issue_fee,                 Float
    attribute :eat_issue_fee_payment_method,  String
    attribute :eat_hearing_fee,                   Float
    attribute :eat_hearing_fee_payment_method,    String
    boolean :address_same_as_applicant
  end
end
