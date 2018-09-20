module ETFees
  class ErrorNotification < SimpleForm::ErrorNotification
    def render
      if has_errors?
        template.render partial: 'shared/error_notification',
                        locals: { message: message }
      end
    end

    def has_errors?
      return false unless object && object.respond_to?(:errors)
      !errors_blank?(object.errors)
    end

    private

    def errors_blank?(errors)
      errors.all? do |_k, v|
        (v.is_a?(ActiveModel::Errors) && errors_blank?(v)) || (v && v.empty? && !v.is_a?(String))
      end
    end

    def message
      if errors[:base].any?
        errors[:base].to_sentence
      else
        error_message
      end
    end
  end
end
