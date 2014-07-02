module ClaimsHelper
  def copy_for(key)
    Markdown.new(I18n.t 'copy.' + key).to_html.html_safe
  end

  def header_text
    t "copy.#{session_manager.current_step}.header"
  end
end
