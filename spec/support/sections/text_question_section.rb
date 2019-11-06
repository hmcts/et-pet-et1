module ET1
  module Test
    class TextQuestionSection < BaseSection
      def set(value)
        input.set value
      end

      private

      element :input, :css, 'input'
    end
  end
end
