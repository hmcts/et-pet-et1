# TODO: take a look at this rubocop warning
# rubocop:disable Style/StructInheritance
class ClaimPresenter < Struct.new(:target)
  SECTIONS = %w[claimant additional_claimants representative respondent
                additional_respondents employment claim_type claim_details claim_outcome
                additional_information].freeze

  def each_section
    SECTIONS.each do |section|
      section      = send(section)
      section_name = section.class.i18n_key

      proc[section_name, section]
    end
  end

  private

  def claimant
    @claimant ||= ClaimantPresenter.new target.primary_claimant
  end

  def additional_claimants
    @additional_claimants ||= additional_claimants_class.new target
  end

  def additional_claimants_class
    if target.additional_claimants_csv.present?
      ClaimantCsvPresenter
    else
      ClaimantCollectionPresenter
    end
  end

  def representative
    @representative ||= RepresentativePresenter.new target.representative
  end

  def respondent
    @respondent ||= RespondentPresenter.new target.primary_respondent
  end

  def employment
    @employment ||= EmploymentPresenter.new target.employment
  end

  def additional_respondents
    @additional_respondents ||= RespondentCollectionPresenter.new target
  end

  def claim_type
    @claim_type ||= ClaimTypePresenter.new target
  end

  def claim_details
    @claim_detail ||= ClaimDetailsPresenter.new target
  end

  def claim_outcome
    @claim_outcome ||= ClaimOutcomePresenter.new target
  end

  def additional_information
    @additional_information ||= AdditionalInformationPresenter.new target
  end

  def your_fee
    @your_fee ||= YourFeePresenter.new target
  end
end
