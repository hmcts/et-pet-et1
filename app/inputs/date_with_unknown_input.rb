#
# An enhanced date input with an 'Unknown' check box - to allow the user
# to specify that they do not know the date that would otherwise be required
#
# Also has the ability to exclude part of the date using the :except option
#
# Here is an example to exclude the day
#
# ```
#   f.input :et_issue_fee_payment_date, as: :date_with_unknown, except: :day
# '''
#
# Or to exclude the day and the month
#
# ```
#   f.input :et_issue_fee_payment_date, as: :date_with_unknown, except: [:day, :month]
# '''
class DateWithUnknownInput < SimpleForm::Inputs::Base

  def input(_wrapper_options = nil)
    field_options = @options.slice(:readonly, :disabled)
    exceptions = Array(@options.fetch(:except, []))
    template.content_tag(defaults[:tag], class: class_name) do
      { day: 2, month: 2, year: 4 }.reduce(active_support_buffer) do |buffer, (part, length)|
        next buffer if exceptions.include?(part)
        buffer << @builder.simple_fields_for(attribute_name, value) do |f|
          f.input part, field_options.merge(as: :tel, maxlength: length)
        end
      end
      active_support_buffer << @builder.input("#{attribute_name}_unknown".to_sym, field_options.merge(as: :boolean, required: true, boolean_style: :inline, label_html: { class: 'unknown' }))
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

  def class_name
    defaults[:class] + ['year-month-date-input', 'know-date-input']
  end

  def active_support_buffer
    @active_support_buffer ||= ActiveSupport::SafeBuffer.new
  end
end
