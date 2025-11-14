class ClaimDetailsForm < Form
  attribute :claim_details,               :string
  attribute :other_known_claimant_names,  :string
  attribute :claim_details_rtf,           :gds_azure_file
  attribute :remove_claim_details_rtf,    :boolean
  attribute :other_known_claimants, :boolean

  before_validation :remove_claim_details_rtf!,
                    if: :remove_claim_details_rtf
  before_validation :reset_other_known_claimant_names!, unless: :other_known_claimants?

  validates :claim_details, length: { maximum: 2500 },
                            presence: true,
                            unless: -> { claim_details_rtf.present? }
  validates :other_known_claimant_names, length: { maximum: 350 }
  validates :other_known_claimants, inclusion: [true, false]
  validates :claim_details_rtf, content_type: {
    in: [
      'application/pdf', 'application/msword', 'application/x-msword', 'application/doc', 'application/vnd.ms-word',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'text/plain', 'application/txt',
      'application/msword', 'application/x-msword', 'application/msword-template', 'image/jpeg', 'image/pjpeg', 'image/bmp',
      'image/x-windows-bmp', 'image/tiff', 'image/x-tiff', 'image/png', 'image/x-png', 'application/vnd.ms-excel',
      'application/msexcel', 'application/x-msexcel', 'application/x-ms-excel', 'application/vnd.ms-excel',
      'application/x-excel', 'application/vnd.ms-excel', 'application/x-excel',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.template', 'application/vnd.ms-powerpoint',
      'application/mspowerpoint', 'application/x-mspowerpoint', 'application/vnd.ms-powerpoint',
      'application/vnd.ms-powerpoint', 'application/vnd.ms-powerpoint', 'application/x-mspowerpoint',
      'application/vnd.openxmlformats-officedocument.presentationml.presentation',
      'application/vnd.openxmlformats-officedocument.presentationml.template',
      'application/vnd.openxmlformats-officedocument.presentationml.slideshow', 'application/rtf', 'text/rtf', 'text/csv',
      'application/csv', 'application/vnd.ms-excel', 'application/x-ole-storage'
    ], message: I18n.t('errors.messages.rtf')
  }

  def claim_form_details_rtf?
    resource.claim_details_rtf.present?
  end

  def attachment_filename
    FilenameCleaner.for claim_details_rtf
  end

  private

  def remove_claim_details_rtf!
    self.attributes = { claim_details_rtf: nil }
    target.remove_claim_details_rtf!
  end

  def reset_other_known_claimant_names!
    self.other_known_claimant_names = nil
  end
end
