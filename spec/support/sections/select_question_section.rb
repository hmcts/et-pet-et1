module ET1
  module Test
    class SelectQuestionSection < BaseSection
      def set(value)
        input.select(translate_if_needed value)
      end

      private

      element :input, :css, 'select'
    end
  end
end
