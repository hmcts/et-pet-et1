module ApplicationHelper
  def page_title(header=I18n.t(".header"))
    "#{header} - Gov.uk"
  end
end
