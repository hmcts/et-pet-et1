module ApplicationHelper
  def page_title(header = generic_header)
    "#{header} - Gov.uk"
  end

  def simple_form_for(record, options = {}, &block)
    super(record, options.merge(builder: ETFees::FormBuilder), &block)
  end

  private def generic_header
    I18n.t("#{controller_name}.#{action_name}.header")
  end
end
