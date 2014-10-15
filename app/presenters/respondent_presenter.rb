class RespondentPresenter < Presenter
  def subsections
    { basic_details: %i<name acas_early_conciliation_certificate_number no_acas_number_reason>,
      contact_details: %i<address telephone_number>,
      work_address: %i<worked_at_same_address> }
  end

  present :name

  def address
    AddressPresenter.present(self)
  end

  def telephone_number
    target.address_telephone_number
  end

  present :acas_early_conciliation_certificate_number

  def no_acas_number_reason
    if target.no_acas_number_reason
      I18n.t "simple_form.options.respondent.no_acas_number_reason.#{target.no_acas_number_reason}"
    end
  end

  def worked_at_same_address
    yes_no target.worked_at_same_address?
  end
end
