module ClaimsHelper
  def copy_for(key)
    Markdown.new(I18n.t 'copy.' + key).to_html.html_safe
  end

  def header_text
    t "copy.#{session_manager.current_step}.header"
  end

  def radio_disclosure_control_for(key)
    content_tag :div do |e|
      label_tag(key) <<
      radio_button_tag(key, true) <<
      t('answer.yes') <<
      radio_button_tag(key, false, true) <<
      t('answer.no')
    end
  end
end
