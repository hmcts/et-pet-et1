class KnowDateInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    template.content_tag(defaults[:tag], class: defaults[:class] + ['know-date-input']) do
      3.downto(1).inject('') { |memo, i| memo + input_segment_for(index: i) }.html_safe
    end
  end

  def input_segment_for(index:)
    id   = name_for(index: index).gsub(/([\[\(])|(\]\[)/, '_').gsub(/[\]\)]/, '')

    key, _ = ActionView::Helpers::DateTimeSelector::POSITION.rassoc index
    maxlength = key == :year ? 4 : 2

    template.content_tag(defaults[:tag], class: defaults[:class] + ["know-date-#{key}"]) do
      template.label_tag(id, I18n.t("datetime.prompts.#{key}")) +
      template.text_field_tag(name_for(index: index), value_for(index: index), id: id, class: input_html_classes, maxlength: maxlength)
    end
  end

  private

  def name_for(index:)
    "#{object_name}[#{attribute_name}(#{index}i)]"
  end

  def defaults
    SimpleForm.wrapper(:default).defaults
  end

  def value_for(index:)
    object.send "#{attribute_name}(#{index}i)"
  end
end
