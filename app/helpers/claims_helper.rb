module ClaimsHelper
  def copy_for(key)
    Markdown.new(I18n.t 'copy.' + key).to_html.html_safe
  end

  def radio_disclosure_control_for(key)
    content_tag :div do |e|
      label_tag(key) <<
      radio_button_tag(key, 'yes') <<
      t('answer.yes') <<
      radio_button_tag(key, 'no', true) <<
      t('answer.no')
    end
  end
end
