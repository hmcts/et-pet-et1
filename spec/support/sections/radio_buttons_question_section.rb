module ET1
  module Test
    class RadioButtonsQuestionSection < BaseSection
      def set(value)
        return if value.nil?

        root_element.choose(translate_if_needed value)
      end

      def assert_error_message(text)
        error_message_element(text: text)
      end

      private

      element :error_message_element, :css, 'span.error'
    end
  end
end
