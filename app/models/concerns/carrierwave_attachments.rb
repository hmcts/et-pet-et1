module CarrierwaveAttachments
  extend ActiveSupport::Concern

  included do
    mount_uploader :additional_information_rtf, AttachmentUploader
    mount_uploader :additional_claimants_csv,   AttachmentUploader
    mount_uploader :pdf,                        ClaimPdfUploader

    delegate :file, to: :additional_information_rtf, prefix: true
    delegate :file, to: :additional_claimants_csv, prefix: true
    delegate :file, :url, :present?, :blank?, to: :pdf, prefix: true

    def attachments
      self.class.uploaders.keys.map(&method(:send)).delete_if { |a| a.file.nil? }
    end
  end
end
