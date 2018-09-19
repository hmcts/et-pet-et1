class AdditionalClaimantsUploadForm < Form
  boolean :has_additional_claimants

  attribute :additional_claimants_csv,        :attachment_uploader_type
  attribute :remove_additional_claimants_csv, :boolean

  delegate :additional_claimants_csv_cache, :additional_claimants_csv_cache=,
    :additional_claimants_csv_record_count=, :remove_additional_claimants_csv!,
    :additional_claimants_csv_file, to: :target

  before_validation :remove_additional_claimants_csv!, if: :file_removal?

  with_options if: :has_additional_claimants do |form|
    form.validates :additional_claimants_csv, presence: true,
                                              unless: :remove_additional_claimants_csv

    form.validates :additional_claimants_csv, content_type: {
      in: ['text/csv', 'text/plain'],
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

  def attachment_filename
    CarrierwaveFilename.for additional_claimants_csv
  end

  private

  def valid_so_far?
    errors.empty?
  end

  def file_removal?
    remove_additional_claimants_csv || !has_additional_claimants
  end
end
