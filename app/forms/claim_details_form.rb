class ClaimDetailsForm < Form
  attribute :claim_details,               :string
  attribute :other_known_claimant_names,  :string
  attribute :claim_details_rtf,           :attachment_uploader_type
  attribute :remove_claim_details_rtf,    :boolean

  boolean :other_known_claimants

  before_validation :remove_claim_details_rtf!,
    if: :remove_claim_details_rtf

  delegate :claim_details_rtf_cache, :claim_details_rtf_cache=,
    :remove_claim_details_rtf!, to: :target

  validates :claim_details, length: { maximum: 2500 },
                            presence: true,
                            unless: -> { claim_details_rtf.present? }
  validates :other_known_claimant_names, length: { maximum: 350 }
  validates :claim_details_rtf, content_type: {
    in: ['text/rtf'], message: I18n.t('errors.messages.rtf')
  }

  def claim_form_details_rtf?
    resource.claim_details_rtf_file.present?
  end

  def attachment_filename
    CarrierwaveFilename.for claim_details_rtf
  end

  def other_known_claimants
    @other_known_claimants ||= other_known_claimant_names?
  end
end
