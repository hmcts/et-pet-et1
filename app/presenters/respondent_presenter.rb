class RespondentPresenter < Presenter
  present :name

  def address
    AddressPresenter.present(self)
  end

  def telephone_number
    target.address_telephone_number
  end

  def acas_early_conciliation_certificate_number
    case
    when target.acas_early_conciliation_certificate_number?
      target.acas_early_conciliation_certificate_number
    when target.no_acas_number_reason
      I18n.t "simple_form.options.respondent.no_acas_number_reason.#{target.no_acas_number_reason}"
    end
  end

  def work_address
    AddressPresenter.present(self, prefix: 'work')
  end

  private

  def items
    if target.worked_at_same_address?
      super.tap { |s| s.delete :work_address }
    else
      super
    end
  end
end
