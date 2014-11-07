class HashInput < SimpleForm::Inputs::Base
  def input(_wrapper_options = nil)
    key = input_html_options.delete(:key)
    #override the params to be in the format that rails will auto correlate back to an
    # attribute hash with key: value
    input_html_options.merge!({:name => "#{self.object_name}[#{attribute_name}][#{key}]"})
    @builder.text_field(attribute_name, input_html_options)
  end
end
