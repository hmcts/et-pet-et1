module ET1
  module Test
    class TextAreaQuestionSection < BaseSection
      def set(value)
        input.set value
      end

      private

      element :input, :css, 'textarea'
    end
  end
end
