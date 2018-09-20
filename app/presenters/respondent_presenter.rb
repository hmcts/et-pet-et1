class RespondentPresenter < Presenter
  PRESENTED_METHODS = [:name, :address, :telephone_number,
                       :acas_early_conciliation_certificate_number, :work_address].freeze
  present :name

  def address
    AddressPresenter.present(self)
  end

  def telephone_number
    target.address_telephone_number
  end

  def acas_early_conciliation_certificate_number
    if target.acas_early_conciliation_certificate_number?
      target.acas_early_conciliation_certificate_number
    elsif target.no_acas_number_reason
      I18n.t "simple_form.options.respondent.no_acas_number_reason.#{target.no_acas_number_reason}"
    end
  end

  def work_address
    AddressPresenter.present(self, prefix: 'work')
  end

  private

  def items
    # NOTE: For some unexplained reason, using the standard 'instance_methods'
    # way of getting 'items' comes out in a different order in OSX - hence these are defined in a constant
    if target.worked_at_same_address?
      PRESENTED_METHODS.dup.tap { |s| s.delete :work_address }
    else
      PRESENTED_METHODS
    end
  end
end
