module Refunds
  class OriginalCaseDetailsForm < Form
    PAYMENT_METHODS = ['unknown', 'card', 'cheque', 'cash'].freeze
    COUNTRY_OF_CLAIMS = ['england_and_wales', 'scotland'].freeze
    TRIBUNAL_OFFICES = ['14', '15', '32', '51', '17', '41', '34', '18',
                        '19', '50', '22', '23', '24', '26', '13', '25',
                        '27', '31', '16', '33', 'unknown'].freeze
    attribute :et_country_of_claim,                     :string
    attribute :et_case_number,                          :string
    attribute :eat_case_number,                         :string
    attribute :et_tribunal_office,                      :string
    attribute :respondent_name,                         :string
    attribute :respondent_address_building,             :string
    attribute :respondent_address_street,               :string
    attribute :respondent_address_locality,             :string
    attribute :respondent_address_county,               :string
    attribute :respondent_address_post_code,            :string
    attribute :claim_had_representative,                :boolean
    attribute :representative_name,                     :string
    attribute :representative_address_building,         :string
    attribute :representative_address_street,           :string
    attribute :representative_address_locality,         :string
    attribute :representative_address_county,           :string
    attribute :representative_address_post_code,        :string
    attribute :additional_information,                  :string
    attribute :address_changed,                         :boolean
    attribute :claimant_address_building,               :string
    attribute :claimant_address_street,                 :string
    attribute :claimant_address_locality,               :string
    attribute :claimant_address_county,                 :string
    attribute :claimant_address_post_code,              :string
    attribute :claimant_name,                           :string
    attribute :claimant_email_address,                  :string
    validates :et_tribunal_office, inclusion: TRIBUNAL_OFFICES, allow_blank: true
    validates :et_country_of_claim, presence: true, inclusion: COUNTRY_OF_CLAIMS
    validates :claim_had_representative, nil_or_empty: true
    validates :address_changed, nil_or_empty: true
    validates :claimant_address_building,
      :claimant_address_street,
      :claimant_address_post_code,
      presence: true
    validates :representative_name,
      :representative_address_building,
      :representative_address_street,
      :representative_address_post_code,
      presence: true,
      if: :claim_had_representative
    validates :respondent_name,
      :respondent_address_building,
      :respondent_address_street,
      presence: true
    validates :et_case_number, format: { with: %r(\A\d{7}\/\d{4}\z) }, allow_blank: true
    validates :eat_case_number, format: { with: %r(\AUKEAT\/\d{4}\/\d{2}\/\d{3}\z) }, allow_blank: true
    before_validation :transfer_personal_info
    before_validation :transfer_address, unless: :address_changed

    private

    def transfer_personal_info
      claimant_name = [
        resource.applicant_title&.titleize,
        resource.applicant_first_name,
        resource.applicant_last_name
      ].join(' ')
      self.claimant_name = claimant_name
      self.claimant_email_address = resource.applicant_email_address
    end

    def transfer_address
      self.claimant_address_building = resource.applicant_address_building
      self.claimant_address_street = resource.applicant_address_street
      self.claimant_address_locality = resource.applicant_address_locality
      self.claimant_address_county = resource.applicant_address_county
      self.claimant_address_post_code = resource.applicant_address_post_code
    end

  end
end
