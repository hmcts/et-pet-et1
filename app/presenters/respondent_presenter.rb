class RespondentPresenter < Presenter
  present :name

  def address
    [address_building, address_street, address_locality, address_county,
      address_post_code].map { |s| sanitize s }.join('<br>').html_safe
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
end
