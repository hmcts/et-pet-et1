class ClaimPresenter < Presenter
  SECTIONS = %w<claimant representative respondent employment claim_detail>.freeze

  include ActionView::Helpers
  include ActionView::Context

  class << self
    def delegate *args
      options = args.extract_options!
      section = options[:to]

      args.each do |meth|
        define_method "#{section}_#{meth}" do
          value = send(section).send(meth)

          if value.present?
            value
          else
            not_entered
          end
        end
      end
    end
  end

  def each_section
    enumerable_sections.each { |section| proc[section] }
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

  private def claim_detail
    @claim_detail ||= ClaimDetailPresenter.new target
  end

  private def not_entered
    content_tag(:span, class: 'not-entered') { I18n.t('presenters.blank') }
  end

  SECTIONS.each do |section|
    klass = "#{section}_presenter".classify.constantize
    delegate *klass.instance_methods(false), to: section
  end

  def claimant_has_representative
    yes_no(target.representative) || not_entered
  end

  def employed_by_employer
    yes_no(target.employment) || not_entered
  end

  alias :respondent_employed_by_employer :employed_by_employer
end
