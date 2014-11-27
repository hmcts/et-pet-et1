class ClaimantCsvPresenter < Presenter
  def group_claim
    yes_no target.additional_claimants_csv.present?
  end

  def file_name
    File.basename(target.additional_claimants_csv.to_s)
  end

  def number_claimants
    target.additional_claimants_csv_record_count
  end

  def self.i18n_key
    'additional_claimants_upload'
  end
end
