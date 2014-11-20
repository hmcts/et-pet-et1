class ClaimantCollectionPresenter < CollectionPresenter
  collection :secondary_claimants
  present    :full_name, :date_of_birth, :address

  def group_claim
    yes_no target.secondary_claimants.any?
  end

  def self.i18n_key
    'additional_claimants'
  end
end
