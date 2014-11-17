class GdsCheckBoxesInput < SimpleForm::Inputs::BooleanInput
  def initialize(builder, attribute_name, column, input_type, options = {})
    options.update as: :boolean, label: false, inline_label: true
    super
  end

  def input(_wrapper_options = nil)
    template.concat build_hidden_field_for_checkbox

    template.content_tag(:span, class: 'checkbox block-label') do
      template.label_tag(label_target) do
        build_check_box_without_hidden_field(input_html_options) + inline_label
      end
    end
  end

  private def label_target
    "#{self.object_name}_#{attribute_name}"
  end
end
