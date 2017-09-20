module Refunds
  class OriginalCaseDetailsForm < Form
    PAYMENT_METHODS = ['card', 'cheque', 'cash']
    attribute :et_case_number,                          String
    attribute :et_tribunal_office,                      String
    attribute :respondent_name,                         String
    attribute :respondent_address_building,               String
    attribute :respondent_address_street,                 String
    attribute :respondent_address_locality,               String
    attribute :respondent_address_county,                 String
    attribute :respondent_address_post_code,              String
    attribute :respondent_address_country,                String
    attribute :representative_name,                     String
    attribute :representative_address_building,               String
    attribute :representative_address_street,                 String
    attribute :representative_address_locality,               String
    attribute :representative_address_county,                 String
    attribute :representative_address_post_code,              String
    attribute :representative_address_country,                String
    attribute :additional_information,                  String
    attribute :et_issue_fee,                            Float
    attribute :et_issue_fee_payment_method,             String
    attribute :et_hearing_fee,                          Float
    attribute :et_hearing_fee_payment_method,           String
    attribute :eat_issue_fee,                           Float
    attribute :eat_issue_fee_payment_method,            String
    attribute :eat_hearing_fee,                         Float
    attribute :eat_hearing_fee_payment_method,          String
    attribute :app_reconsideration_fee,                 Float
    attribute :app_reconsideration_fee_payment_method,  String
    boolean :address_changed
    attribute :claimant_address_building,               String
    attribute :claimant_address_street,                 String
    attribute :claimant_address_locality,               String
    attribute :claimant_address_county,                 String
    attribute :claimant_address_post_code,              String
    attribute :claimant_address_country,                String

    validates :claimant_address_building, :claimant_address_street, :claimant_address_post_code, presence: true
    validates :representative_name, :representative_address_building, :representative_address_street, :representative_address_post_code, presence: true
    validates :respondent_name, :respondent_address_building, :respondent_address_street, :respondent_address_post_code, presence: true
    before_validation :transfer_address, unless: :address_changed

    private

    def transfer_address
      self.claimant_address_building = resource.applicant_address_building
      self.claimant_address_street = resource.applicant_address_street
      self.claimant_address_locality = resource.applicant_address_locality
      self.claimant_address_county = resource.applicant_address_county
      self.claimant_address_post_code = resource.applicant_address_post_code
      self.claimant_address_country = resource.applicant_address_country
    end
  end
end
