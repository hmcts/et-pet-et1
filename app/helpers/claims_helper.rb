module ClaimsHelper
  def copy_for(key, options = {})
    Markdown.new(I18n.t 'copy.' + key, options).to_html.html_safe
  end

  def copy_text
    t "copy.#{current_step}"
  end

  def header_text
    copy_text[:header]
  end
end
