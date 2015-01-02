class AdditionalRespondentsForm
  class AdditionalRespondent < CollectionForm::Resource
    NAME_LENGTH    = 100
    NO_ACAS_REASON = %w<joint_claimant_has_acas_number acas_has_no_jurisdiction
      employer_contacted_acas interim_relief claim_against_security_services>.freeze

    include AddressAttributes

    attribute :name,                                       String
    attribute :acas_early_conciliation_certificate_number, String
    attribute :no_acas_number_reason,                      String

    booleans :no_acas_number, :_destroy

    delegate :id, :id=, to: :resource

    before_validation :reset_acas_number!,  if: :no_acas_number?

    validates :name, presence: true, length: { maximum: NAME_LENGTH }

    validates :no_acas_number_reason,
      inclusion: { in: NO_ACAS_REASON, allow_blank: true },
      presence:  { if: -> { no_acas_number? } }

    validates :acas_early_conciliation_certificate_number,
      presence: { unless: -> { no_acas_number? } }

    def no_acas_number
      @no_acas_number ||= target.persisted? && acas_early_conciliation_certificate_number.blank?
    end

    private

    def reset_acas_number!
      self.acas_early_conciliation_certificate_number = nil
    end
  end
end
