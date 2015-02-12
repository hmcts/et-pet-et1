class ClaimDetailsForm < Form
  attribute :claim_details,                     String
  attribute :other_known_claimant_names,        String
  attribute :claim_details_rtf,        AttachmentUploader
  attribute :remove_claim_details_rtf, Boolean

  before_validation :remove_claim_details_rtf!,
    if: :remove_claim_details_rtf

  delegate :claim_details_rtf_cache, :claim_details_rtf_cache=,
    :remove_claim_details_rtf!, to: :target

  validates :claim_details, length: { maximum: 5000 }, presence: true
  validates :other_known_claimant_names, length: { maximum: 350 }
  validates :claim_details_rtf, content_type: {
    in: %w<text/rtf text/plain>,
    message: I18n.t('errors.messages.rtf')
  }

  boolean :other_known_claimants

  def has_claim_details_rtf?
    resource.claim_details_rtf_file.present?
  end

  def attachment_filename
    CarrierwaveFilename.for claim_details_rtf
  end

  def other_known_claimants
    @other_known_claimants ||= other_known_claimant_names?
  end
end
