class ClaimantPresenter < Presenter
  def full_name
    [t("simple_form.options.claimant.title.#{title}"), first_name, last_name].join ' '
  end

  def gender
    I18n.t "simple_form.options.claimant.gender.#{target.gender}"
  end

  def date_of_birth
    date target.date_of_birth
  end

  def address
    [address_building, address_street, address_locality, address_county,
      address_post_code].compact.map { |s| sanitize s }.join('<br>').html_safe
  end

  def telephone_number
    address_telephone_number
  end

  present :mobile_number

  def contact_preference
    t "simple_form.options.claimant.contact_preference.#{target.contact_preference}"
  end

  def is_disabled
    yes_no special_needs.present?
  end

  def is_applying_for_remission
    yes_no target.applying_for_remission?
  end
end
