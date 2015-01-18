class KnowDateInput < SimpleForm::Inputs::Base
  def input(_wrapper_options = nil)
    template.content_tag(defaults[:tag], class: defaults[:class] + ['know-date-input']) do
      { day: 2, month: 2, year: 4 }.reduce(ActiveSupport::SafeBuffer.new) do |buffer, (part, length)|

        buffer << @builder.simple_fields_for(attribute_name, value) do |f|
          f.input part, as: :tel, maxlength: length
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
    else
      value
    end
  end
end
