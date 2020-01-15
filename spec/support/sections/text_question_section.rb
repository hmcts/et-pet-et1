require_relative './base_section'
module ET1
  module Test
    class TextQuestionSection < BaseSection
      def set(value)
        input.set value
      end

      def assert_error_message(text)
        error_message_element(text: text)
      end

      private

      element :input, :fillable_field
      element :error_message_element, :css, 'span.error'
    end
  end
end
