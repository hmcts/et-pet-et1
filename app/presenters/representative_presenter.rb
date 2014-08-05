class RepresentativePresenter < Presenter
  def type
    t "simple_form.options.representative.type.#{target.type}"
  end

  present :organisation_name, :name

  def address
    [address_building, address_street, address_locality, address_county,
      address_post_code].map { |s| sanitize s }.join('<br>').html_safe
  end

  def telephone_number
    address_telephone_number
  end

  present :mobile_number, :email_address, :dx_number

  def contact_preference
    t "simple_form.options.claimant.contact_preference.#{target.contact_preference}"
  end
end
