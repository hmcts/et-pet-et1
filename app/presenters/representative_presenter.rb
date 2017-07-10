class RepresentativePresenter < Presenter
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

  private

  def items
    if target.present?
      # Array#- doesn't preserve the receiver's ordering
      super.tap { |s| s.delete :has_representative }
    else
      %i[has_representative]
    end
  end
end
