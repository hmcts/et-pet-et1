class KnowDateInput < SimpleForm::Inputs::Base

  def input(_wrapper_options = nil)
    field_options = @options.slice(:readonly, :disabled)
    template.content_tag(defaults[:tag], class: class_name) do
      { day: 2, month: 2, year: 4 }.reduce(active_support_buffer) do |buffer, (part, length)|

        buffer << @builder.simple_fields_for(attribute_name, value) do |f|
          f.input part, field_options.merge(as: :tel, maxlength: length)
        end

      end
    end
  end

  private

  def defaults
    SimpleForm.wrapper(:default).defaults
  end

  # A value could be a Hash if the Virtus type coercion failed e.g.
  # { day: 'lol', month: 'dot', year: 'biz' } won't cast to a date.
  # If the failboat docks, wrap the hash in an OStruct so the form builder
  # can display le failz

  def value
    value = object.send attribute_name
    if value.is_a? Hash
      OpenStruct.new value
    elsif value.is_a? ActionController::Parameters
      OpenStruct.new value.to_unsafe_hash
    else
      value
    end
  end

  def class_name
    defaults[:class] + ['know-date-input']
  end

  def active_support_buffer
    ActiveSupport::SafeBuffer.new
  end
end
