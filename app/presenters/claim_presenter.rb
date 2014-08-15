class ClaimPresenter < Struct.new(:claim)
  include ActionView::Helpers
  include ActionView::Context

  SECTIONS  = %w<claimant representative respondent employment claim_detail>.freeze
  RELATIONS = %w<primary_claimant representative primary_respondent employment claim_detail>.freeze

  def each_section
    enumerable_sections.each { |section| proc[section] }
  end

  private def enumerable_sections
    @enumerable_sections ||= SECTIONS.dup.tap do |arr|
      arr.delete('employment')     if claim.employment.blank?
      arr.delete('representative') if claim.representative.blank?
    end
  end

  private def yes_no(val)
    I18n.t "simple_form.#{val ? 'yes' : 'no'}"
  end

  def self.add_delegator_for(section, relation)
    presenter = "#{section}_presenter".classify.constantize

    define_method(section) do
      if instance_variable_defined? :"@#{section}"
        instance_variable_get :"@#{section}"
      else
        instance_variable_set :"@#{section}", presenter.new(claim.send relation)
      end
    end

    presenter.instance_methods(false).each do |meth|
      define_method("#{section}_#{meth}") do
        value = send(section).send(meth).__value__

        if value.present?
          value
        else
          content_tag(:span, class: 'not-entered') { I18n.t('presenters.blank') }
        end
      end
    end
  end

  Hash[SECTIONS.zip RELATIONS].each { |section, relation| add_delegator_for(section, relation) }

  def claimant_has_representative
    yes_no claim.representative.present?
  end

  def employed_by_employer
    yes_no claim.employment.present?
  end

  alias :respondent_employed_by_employer :employed_by_employer
end
