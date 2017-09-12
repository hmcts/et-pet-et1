module Refunds
  class OriginalCaseDetailsForm < Form
    PAYMENT_METHODS = ['card', 'cheque', 'cash']
    attribute :et_case_number,                    String
    attribute :et_tribunal_office,                String
    attribute :respondent_name,                   String
    attribute :respondent_post_code,              String
    attribute :claimant_name,                     String
    attribute :additional_information,           String
    attribute :claimant_address_post_code,        String
    attribute :et_issue_fee,                      Float
    attribute :et_issue_fee_date_paid,            Date
    attribute :et_issue_fee_payment_method,       String
    attribute :et_hearing_fee,                    Float
    attribute :et_hearing_fee_date_paid,          Date
    attribute :et_hearing_fee_payment_method,     String
    attribute :eat_lodgement_fee,                 Float
    attribute :eat_lodgement_fee_date_paid,       Date
    attribute :eat_lodgement_fee_payment_method,  String
    attribute :eat_hearing_fee,                   Float
    attribute :eat_hearing_fee_date_paid,         Date
    attribute :eat_hearing_fee_payment_method,    String
    attribute :app_reconsideration_fee,           Float
    attribute :app_reconsideration_fee_date_paid, Date
    attribute :app_reconsideration_fee_payment_method, String
    boolean :address_same_as_applicant
  end
end
