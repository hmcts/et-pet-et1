class AdditionalClaimantsUploadForm < Form
  boolean :has_additional_claimants

  attribute :additional_claimants_csv,        AttachmentUploader
  attribute :remove_additional_claimants_csv, Boolean

  delegate :additional_claimants_csv_cache, :additional_claimants_csv_cache=,
    :additional_claimants_csv_record_count=, :additional_claimants_csv_file,
    :delete_additional_claimants_csv!, to: :target

  before_validation :delete_additional_claimants_csv!, unless: :has_additional_claimants

  with_options if: :has_additional_claimants do |form|
    form.validates :additional_claimants_csv, presence: true
    form.validates :additional_claimants_csv, content_type: {
      in: %w<text/csv text/plain>,
      message: I18n.t('errors.messages.csv')
    }
    form.validates :additional_claimants_csv,
      additional_claimants_csv: true, if: :valid_so_far?
  end

  def has_additional_claimants_csv?
    additional_claimants_csv_file.present?
  end

  def has_additional_claimants
    if defined? @has_additional_claimants
      @has_additional_claimants
    else
      @has_additional_claimants = has_additional_claimants_csv? || errors.present?
    end
  end

  def csv_errors
    errors[:additional_claimants_csv]
  end

  def erroneous_line_number
    errors[:erroneous_line_number].first
  end

  private def valid_so_far?
    errors.empty?
  end
end
