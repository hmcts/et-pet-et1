class ClaimPresenter < Struct.new(:claim)
  SECTIONS  = %w<claimant representative respondent employment claim_detail>.freeze
  RELATIONS = %w<primary_claimant representative primary_respondent employment claim_detail>.freeze

  def claimant_has_representative
    yes_no claim.representative.present?
  end

  def employed_by_employer
    yes_no claim.employment.present?
  end

  alias :respondent_employed_by_employer :employed_by_employer

  def skip?(section)
    send(section).target.blank?
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

    delegate *presenter.instance_methods(false), to: section, prefix: true
  end

  Hash[SECTIONS.zip RELATIONS].each { |section, relation| add_delegator_for(section, relation) }
end
