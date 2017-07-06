# TODO: take a look at this rubocop warning
# rubocop:disable Style/StructInheritance
class AdditionalClaimantsCsv::BaseCsv < Struct.new(:claim)
  delegate :additional_claimants_csv, to: :claim

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
# rubocop:enable Style/StructInheritance
