class AdditionalClaimantsCsv::BaseCsv < Struct.new(:claim)
  delegate :additional_claimants_csv, to: :claim

  def csv_path
    additional_claimants_csv.path
  end

  def csv_collection
    CSV.open(csv_path, headers: true).lazy
  end

  def model_builder
    @model_builder ||= AdditionalClaimantsCsv::ModelBuilder.new
  end
end
