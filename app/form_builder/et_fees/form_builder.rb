module ETFees
  class FormBuilder < SimpleForm::FormBuilder
    def error_notification(options = {})
      ETFees::ErrorNotification.new(self, options).render
    end
  end
end
