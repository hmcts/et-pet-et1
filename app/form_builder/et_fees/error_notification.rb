module ETFees
  class ErrorNotification < SimpleForm::ErrorNotification
    def render
      if has_errors?
        template.render(
          partial: 'shared/error_notification',
          locals: { message: error_message, errors: ids_and_errors }
        )
      end
    end

    private

    def ids_and_errors
      errors.map { |attr, err| ["##{object_name}_#{attr}", err] }
    end
  end
end
