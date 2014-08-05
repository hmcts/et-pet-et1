class GdsCheckBoxesInput < SimpleForm::Inputs::BooleanInput
  def initialize(builder, attribute_name, column, input_type, options = {})
    options.update as: :boolean, label:false, inline_label: true
    super
  end

  def input(wrapper_options = nil)
    template.concat build_hidden_field_for_checkbox

    template.label_tag('div', class: 'block-label') do
      build_check_box_without_hidden_field(input_html_options) + inline_label
    end
  end
end
