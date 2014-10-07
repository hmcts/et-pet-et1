class PdfForm::BaseDelegator < SimpleDelegator
  def format_postcode(postcode)
    formatted_postcode = ''
    if postcode.present?
      uk_postcode = UKPostcode.new(postcode)
      formatted_postcode = ("%-4s" % uk_postcode.outcode) + uk_postcode.incode
    end
    formatted_postcode
  end

  def use_or_off(field, options)
    field = field.to_s
    options.map(&:to_s).include?(field) ? field : 'Off'
  end

  def tri_state(value, yes: 'yes')
    {nil => 'Off', false => 'no', true => yes}[value]
  end

  def dual_state(value, yes: 'yes')
   {nil => 'Off', false => 'Off', true => yes}[value]
  end
end
