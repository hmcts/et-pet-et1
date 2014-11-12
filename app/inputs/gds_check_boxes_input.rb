class GdsCheckBoxesInput < SimpleForm::Inputs::BooleanInput
  def initialize(builder, attribute_name, column, input_type, options = {})
    options.update as: :boolean, label: false, inline_label: true
    super
  end

  def input(_wrapper_options = nil)
    template.concat build_hidden_field_for_checkbox

    template.label_tag(label_target, class: 'block-label') do
      build_check_box_without_hidden_field(input_html_options) + inline_label
    end
  end

  private def label_target
    "#{self.object_name}_#{attribute_name}"
  end
end
