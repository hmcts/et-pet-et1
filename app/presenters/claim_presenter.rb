class ClaimPresenter < Presenter
  SECTIONS  = %w<claimant representative respondent employment claim_detail>.freeze

  def skip?(section)
    send(section).target.blank?
  end

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

  def claim_detail
    @claim_detail ||= ClaimDetailPresenter.new target
  end

  SECTIONS.each do |section|
    klass = "#{section}_presenter".classify.constantize
    delegate *klass.instance_methods(false), to: section, prefix: true
  end

  def claimant_has_representative
    yes_no target.representative.present?
  end

  def employed_by_employer
    yes_no target.employment.present?
  end

  alias :respondent_employed_by_employer :employed_by_employer
end
