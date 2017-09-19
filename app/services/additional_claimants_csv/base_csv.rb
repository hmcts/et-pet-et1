class AdditionalClaimantsCsv::BaseCsv
  delegate :additional_claimants_csv, to: :claim

  attr_reader :claim

  def initialize(claim)
    @claim = claim
  end

  def csv_path
    additional_claimants_csv.path
  end

  def csv_collection
    CSV.new(additional_claimants_csv.read, headers: true).lazy
  end

  def model_builder
    @model_builder ||= AdditionalClaimantsCsv::ModelBuilder.new
  end
end
