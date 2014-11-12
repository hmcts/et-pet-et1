class ClaimPresenter < Struct.new(:target)
  SECTIONS = %w<claimant representative respondent employment
    claim_type claim_details claim_outcome additional_information your_fee>.freeze

  def each_section
    enumerable_sections.each do |section|
      section      = send(section)
      section_name = section.class.name.underscore.sub(/_presenter\Z/, '')

      proc[section_name, section]
    end
  end

  private def enumerable_sections
    @enumerable_sections ||= SECTIONS.dup.tap do |arr|
      arr.delete('employment')     if target.employment.blank?
      arr.delete('representative') if target.representative.blank?
    end
  end

  private def claimant
    @claimant ||= ClaimantPresenter.new target.primary_claimant
  end

  private def representative
    @representative ||= RepresentativePresenter.new target.representative
  end

  private def respondent
    @respondent ||= RespondentPresenter.new target.primary_respondent
  end

  private def employment
    @employment ||= EmploymentPresenter.new target.employment
  end

  private def claim_type
    @claim_type ||= ClaimTypePresenter.new target
  end

  private def claim_details
    @claim_detail ||= ClaimDetailsPresenter.new target
  end

  private def claim_outcome
    @claim_outcome ||= ClaimOutcomePresenter.new target
  end

  private def additional_information
    @additional_information ||= AdditionalInformationPresenter.new target
  end

  private def your_fee
    @your_fee ||= YourFeePresenter.new target
  end
end
