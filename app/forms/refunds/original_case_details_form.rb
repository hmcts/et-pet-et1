module Refunds
  class OriginalCaseDetailsForm < Form
    PAYMENT_METHODS = ['card', 'cheque', 'cash']
    COUNTRY_OF_CLAIMS = ['england_and_wales', 'scotland']
    TRIBUNAL_OFFICES = ['14', '15', '32', '51', '17', '41', '34', '18', '19', '50', '22', '23', '24', '26', '13', '25', '27', '31', '16', '33', '99']
    attribute :et_country_of_claim,                     String
    attribute :et_case_number,                          String
    attribute :et_tribunal_office,                      String
    attribute :respondent_name,                         String
    attribute :respondent_address_building,               String
    attribute :respondent_address_street,                 String
    attribute :respondent_address_locality,               String
    attribute :respondent_address_county,                 String
    attribute :respondent_address_post_code,              String
    attribute :claim_had_representative,                  Boolean
    attribute :representative_name,                     String
    attribute :representative_address_building,               String
    attribute :representative_address_street,                 String
    attribute :representative_address_locality,               String
    attribute :representative_address_county,                 String
    attribute :representative_address_post_code,              String
    attribute :additional_information,                  String
    boolean :address_changed
    attribute :claimant_address_building,               String
    attribute :claimant_address_street,                 String
    attribute :claimant_address_locality,               String
    attribute :claimant_address_county,                 String
    attribute :claimant_address_post_code,              String

    validates :et_tribunal_office, inclusion: TRIBUNAL_OFFICES, allow_blank: true
    validates :et_country_of_claim, presence: true, inclusion: COUNTRY_OF_CLAIMS
    validates :claim_had_representative, nil: true
    validates :claimant_address_building, :claimant_address_street, :claimant_address_post_code, presence: true
    validates :representative_name, :representative_address_building, :representative_address_street, :representative_address_post_code, presence: true, if: :claim_had_representative
    validates :respondent_name, :respondent_address_building, :respondent_address_street, presence: true
    before_validation :transfer_address, unless: :address_changed

    private

    def transfer_address
      self.claimant_address_building = resource.applicant_address_building
      self.claimant_address_street = resource.applicant_address_street
      self.claimant_address_locality = resource.applicant_address_locality
      self.claimant_address_county = resource.applicant_address_county
      self.claimant_address_post_code = resource.applicant_address_post_code
    end

  end
end
