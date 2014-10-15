class RepresentativePresenter < Presenter
  def subsections
    { has_representative: %i<has_representative>,
      basic_details: %i<type organisation_name name>,
      contact_details: %i<address telephone_number mobile_number email_address dx_number contact_preference> }
  end

  def has_representative
    yes_no target.present?
  end

  def type
    if target.type
      t "simple_form.options.representative.type.#{target.type}"
    end
  end

  present :organisation_name, :name

  def address
    AddressPresenter.present(self)
  end

  def telephone_number
    address_telephone_number
  end

  present :mobile_number, :email_address, :dx_number

  def contact_preference
    if target.contact_preference
      t "simple_form.options.representative.contact_preference.#{target.contact_preference}"
    end
  end
end
