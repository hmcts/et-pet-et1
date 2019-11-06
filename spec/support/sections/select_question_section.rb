module ET1
  module Test
    class SelectQuestionSection < BaseSection
      def set(value)
        input.select(translate_if_needed value)
      end

      def assert_error_message(text)
        error_message_element(text: text)
      end

      private

      element :input, :css, 'select'
      element :error_message_element, :css, 'span.error'
    end
  end
end
