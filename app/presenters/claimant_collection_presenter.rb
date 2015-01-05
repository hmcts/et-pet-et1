class ClaimantCollectionPresenter < CollectionPresenter
  collection :secondary_claimants
  present    :full_name, :date_of_birth, :address

  def group_claim
    yes_no secondary_claimants.any? || additional_claimants_csv_record_count > 0
  end

  def self.i18n_key
    'additional_claimants'
  end
end
