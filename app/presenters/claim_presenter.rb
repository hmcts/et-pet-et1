class ClaimPresenter < Struct.new(:target)
  SECTIONS = %w<claimant representative respondent employment
    claim_type claim_details claim_outcome additional_information your_fee>.freeze

  def each_section
    SECTIONS.each do |section|
      section      = send(section)
      section_name = section.class.name.underscore.sub(/_presenter\Z/, '')

      proc[section_name, section]
    end
  end

  private

  def claimant
    @claimant ||= ClaimantPresenter.new target.primary_claimant
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
