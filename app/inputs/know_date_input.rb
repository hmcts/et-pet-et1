class KnowDateInput < SimpleForm::Inputs::Base

  def input(wrapper_options = nil)
    value    = object.send attribute_name
    defaults = SimpleForm.wrapper(:default).defaults

    template.instance_exec(self) do |b|
      content_tag(defaults[:tag], class: defaults[:class] + ['know-date-input']) do
        3.downto(1) do |i|
          name = "#{b.object_name}[#{b.attribute_name}(#{i}i)]"
          id   = name.gsub(/([\[\(])|(\]\[)/, '_').gsub(/[\]\)]/, '')

          key, _ = ActionView::Helpers::DateTimeSelector::POSITION.rassoc i
          maxlength = key == :year ? 4 : 2

          concat(content_tag(defaults[:tag], class: defaults[:class] + ["know-date-#{key}"]) do
            concat label_tag id, t("datetime.prompts.#{key}")
            concat text_field_tag name, value.try(key),
              id: id, class: b.input_html_classes, maxlength: maxlength
          end)
        end
      end
    end
  end
end
