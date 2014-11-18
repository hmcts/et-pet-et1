module ApplicationHelper
  def page_title(header=generic_header)
    "#{header} - Gov.uk"
  end

  private def generic_header
    I18n.t("#{controller_name}.#{action_name}.header")
  end
end
