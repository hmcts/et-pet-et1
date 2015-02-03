module ETFees
  class ErrorNotification < SimpleForm::ErrorNotification
    def render
      if has_errors?
        template.render partial: 'shared/error_notification',
          locals: { message: message }
      end
    end

    private

    def message
      if errors[:base].any?
        errors[:base].to_sentence
      else
        error_message
      end
    end
  end
end
