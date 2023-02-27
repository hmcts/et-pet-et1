class AdditionalClaimantsUploadForm < Form
  boolean :has_additional_claimants

  attribute :additional_claimants_csv, :gds_azure_file
  attribute :remove_additional_claimants_csv, :boolean

  delegate  :additional_claimants_csv_record_count=, to: :target

  before_validation :remove_additional_claimants_csv!, if: :file_removal?

  with_options if: :has_additional_claimants do |form|
    form.validates :additional_claimants_csv, presence: true,
                                              unless: :remove_additional_claimants_csv

    validate do
      next if additional_claimants_csv.nil?
      next if additional_claimants_csv['content_type'].in?(['text/csv', 'text/plain', 'application/csv',
                                                            'application/vnd.ms-excel'])

      errors.add(:additional_claimants_csv, I18n.t('errors.messages.csv'))
    end

    form.validates :additional_claimants_csv,
                   additional_claimants_csv: true, if: :valid_so_far?
  end

  def has_additional_claimants_csv?
    additional_claimants_csv.present?
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

  def csv_error_lines
    error = errors.group_by_attribute[:additional_claimants_csv]&.find { |e| e.type == :invalid }
    return [] if error.nil?

    error.options[:line_errors]
  end

  def erroneous_line_number
    errors[:erroneous_line_number].first
  end

  def attachment_filename
    FilenameCleaner.for additional_claimants_csv
  end

  private

  def valid_so_far?
    errors.empty?
  end

  def file_removal?
    remove_additional_claimants_csv || !has_additional_claimants
  end

  def remove_additional_claimants_csv!
    self.attributes = { additional_claimants_csv_record_count: 0, additional_claimants_csv: nil }
    target.remove_additional_claimants_csv!
  end
end
