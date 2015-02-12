class ClaimDetailsForm < Form
  attribute :claim_details,                     String
  attribute :other_known_claimant_names,        String
  attribute :additional_information_rtf,        AttachmentUploader
  attribute :remove_additional_information_rtf, Boolean

  before_validation :remove_additional_information_rtf!,
    if: :remove_additional_information_rtf

  delegate :additional_information_rtf_cache, :additional_information_rtf_cache=,
    :remove_additional_information_rtf!, to: :target

  validates :claim_details, length: { maximum: 5000 }, presence: true
  validates :other_known_claimant_names, length: { maximum: 350 }
  validates :additional_information_rtf, content_type: {
    in: %w<text/rtf text/plain>,
    message: I18n.t('errors.messages.rtf')
  }

  boolean :other_known_claimants

  def has_additional_information_rtf?
    resource.additional_information_rtf_file.present?
  end

  def attachment_filename
    CarrierwaveFilename.for additional_information_rtf
  end

  def other_known_claimants
    @other_known_claimants ||= other_known_claimant_names?
  end
end
