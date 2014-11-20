class RespondentCollectionPresenter < CollectionPresenter
  collection :secondary_respondents
  present    :name, :acas_early_conciliation_certificate_number, :address

  def additional_respondents
    yes_no target.secondary_respondents.any?
  end

  def self.i18n_key
    'additional_respondents'
  end
end
