class ClaimantPresenter < Presenter
  def subsections
    { personal_details: %i<full_name gender date_of_birth is_disabled>,
      contact_details: %i<address telephone_number mobile_number email_address contact_preference> }
  end

  def full_name
    salutation = t("simple_form.options.claimant.title.#{title}") if target.title
    [salutation, first_name, last_name].compact.join ' '
  end

  def gender
    if target.gender
      I18n.t "simple_form.options.claimant.gender.#{target.gender}"
    end
  end

  def date_of_birth
    date target.date_of_birth
  end

  def address
    AddressPresenter.present(self)
  end

  def telephone_number
    address_telephone_number
  end

  present :mobile_number, :email_address

  def contact_preference
    if target.contact_preference
      t "simple_form.options.claimant.contact_preferences.#{target.contact_preference}"
    end
  end

  def is_disabled
    yes_no special_needs
  end

  def is_applying_for_remission
    yes_no target.applying_for_remission?
  end
end
