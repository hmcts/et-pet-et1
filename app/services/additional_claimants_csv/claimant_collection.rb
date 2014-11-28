class AdditionalClaimantsCsv::ClaimantCollection < AdditionalClaimantsCsv::BaseCsv
  delegate :claimants, to: :claim, prefix: true

  def prepare
    csv_path ? prepare_with_csv_models : claimants
  end

  private

  def prepare_with_csv_models
    [claimants, csv_collection].lazy.flat_map do |collection|
      collection.map do |item|
        item.is_a?(CSV::Row) ? model_builder.build_claimant(item.fields) : item
      end
    end
  end

  def claimants
    claim_claimants.lazy
  end
end
